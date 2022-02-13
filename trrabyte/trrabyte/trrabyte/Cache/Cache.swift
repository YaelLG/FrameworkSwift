//
//  Cache+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

open class Cache {
    static let shared = Cache(sizeMB: 20, concurrentOperations: 5)
    private let operationQueue: OperationQueue
    private let imagesPath: String
    private let finalSize: UInt64
    private var pathImages: [String] = []
    private var sizeImagesDirectory: UInt64 = 0
    private let semaphore = DispatchSemaphore(value: 0)
    private let queue = DispatchQueue(label: "deleteItemsQueue", attributes: .concurrent)
    private let globalQueue = DispatchQueue.global()
    
    init(sizeMB: CGFloat, concurrentOperations: Int) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        finalSize = UInt64(sizeMB * 1024.0 * 1024)
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = concurrentOperations
        imagesPath = (documentPath as NSString).appendingPathComponent("imagesFiles")
        sizeImagesDirectory = createDirectoryPath(imagesPath)
        pathImages = contentsOrderByDateOfDirector(imagesPath)
    }
    
    //Ask for an specific image
    func imageWithKey(_ key: String) -> UIImage? {
        let isPNG = key.contains(".png") || key.contains(".PNG")
        let md5Key = key.md5() + "\(isPNG ? ".png" : ".jpg")"
        let defaultManager = FileManager.default
        do {
            let fileURL = try urlPathForSaveOrDelete(md5Key)
            guard let imageData = defaultManager.contents(atPath: fileURL.path) else { return nil }
            return UIImage(data: imageData)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func searchImageWithUrl(url: String, cache: Bool, success: @escaping (UIImage?) -> Void) {
        if let image = imageWithKey(url) {
            success(image)
        } else {
            operationQueue.addOperation { [weak self] in
                self?.downloadImage(from: url, cache: cache, successImage: success)
            }
        }
    }
    
    func downloadImage(from url: String, cache: Bool,
                       successImage: @escaping (UIImage?) -> Void) {
        guard let urlRequest = URL(string: url),
              let data = try? Data(contentsOf: urlRequest),
              let image = UIImage(data: data) else {
            successImage(nil)
            return
        }
        if cache { saveImage(image: image, key: url) }
        successImage(image)
    }
    
    //Remove the whole directory's image
    func clearImagesCache() throws {
        let fileManager = FileManager.default
        try fileManager.removeItem(atPath: imagesPath)
    }
    
    //Return path where you've saved the file
    func saveImage(image: UIImage, key: String) {
        let isPNG = key.contains(".png") || key.contains(".PNG")
        let data = isPNG ? image.pngData() : image.jpegData(compressionQuality: 0.1)
        let md5Key = key.md5() + "\(isPNG ? ".png" : ".jpg")"
        guard let imageData = data else { return }
        sizeImagesDirectory += UInt64(imageData.count)
        do {
            let fileURL = try urlPathForSaveOrDelete(md5Key)
            try imageData.write(to: fileURL)
            pathImages.append(md5Key)
            removeOldElementToKeepSizeLimit()
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    fileprivate func urlPathForSaveOrDelete(_ realKey: String) throws -> URL {
        let urlImages = "imagesFiles/\(realKey)"
        return try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(urlImages)
    }
    
    //If there is no space available we started to remove data
    fileprivate func removeOldElementToKeepSizeLimit() {
        globalQueue.async { [weak self] in
            self?.queue.async { [weak self] in
                guard let self = self else { return }
                while self.sizeImagesDirectory > self.finalSize,
                      let path = self.pathImages.first {
                    do {
                        let fileURL = try self.urlPathForSaveOrDelete(path)
                        let fileDict = try FileManager.default
                            .attributesOfItem(atPath: fileURL.path) as NSDictionary
                        try FileManager.default.removeItem(at: fileURL)
                        self.sizeImagesDirectory -= fileDict.fileSize()
                        self.removePath(path)
                        self.semaphore.signal()
                    } catch let error as NSError {
                        if error.code == 260 {
                            self.removePath(path)
                        }
                        self.semaphore.signal()
                    }
                }
            }
            self?.semaphore.wait()
        }
    }

    fileprivate func removePath(_ path: String) {
        if let index = pathImages.firstIndex(where: { $0 == path }) {
            pathImages.remove(at: index)
        }
    }
    
    //Create directory at specified path
    fileprivate func createDirectoryPath(_ directoryPath: String) -> UInt64 {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: directoryPath, isDirectory: nil) {
            do {
                try fileManager.createDirectory(atPath: directoryPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                let files = try FileManager.default.subpathsOfDirectory(atPath: directoryPath)
                let filesEnumerated = files.enumerated()
                return try sizeDirectoryPath(filesEnumerated, directoryPath)
            } catch let error as NSError {
                debugPrint(error.localizedDescription)
            }
        }
        return 0
    }
    
    fileprivate func sizeDirectoryPath(_ enumerated: EnumeratedSequence<[String]>,
                                       _ directoryPath: String) throws -> UInt64 {
        var fileSize = UInt64(0)
        for value in enumerated.enumerated() {
            let fileDictionary: NSDictionary = try FileManager.default.attributesOfItem(atPath: (directoryPath as NSString).appendingPathComponent(value.element.element)) as NSDictionary
            fileSize += UInt64(fileDictionary.fileSize())
        }
        return fileSize
    }
    
    fileprivate func contentsOrderByDateOfDirector(_ directoryPath: String) -> [String] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
            let filesNProperties: [JSON] = createArrayWithDates(files: files, directoryPath)
            //Sort by creation date
            let sortedFiles = sortedFilesByDate(arrayToSort: filesNProperties)
            return getOnlyPaths(sortedFiles)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        return []
    }
    
    fileprivate func createArrayWithDates(files: [String],
                                          _ directoryPath: String) -> [JSON] {
        var filesNProperties: [JSON] = []
        for file in files {
            let filePath = (directoryPath as NSString).appendingPathComponent(file)
            let properties = try? FileManager.default.attributesOfItem(atPath: filePath)
            
            if properties == nil {
                let modDate = properties?[FileAttributeKey.modificationDate] as? Date
                filesNProperties.append(["path": file, "lastModDate": modDate ?? Date()])
            }
        }
        return filesNProperties
    }
    
    fileprivate func sortedFilesByDate(arrayToSort: [JSON]) -> [JSON] {
        return arrayToSort.sorted(by: {
            guard let date = $0["lastModDate"] as? Date,
                  let dateNext = $1["lastModDate"] as? Date else {
                return false
            }
            return date < dateNext
        })
    }
    
    fileprivate func getOnlyPaths(_ sortedFiles: [JSON]) -> [String] {
        var paths: [String] = []
        for dict in sortedFiles {
            if let path = dict["path"] as? String {
                paths.append(path)
            }
        }
        return paths
    }
}
