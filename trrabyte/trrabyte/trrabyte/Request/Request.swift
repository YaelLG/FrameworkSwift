//
//  Request.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

typealias JSON = [String: Any]

enum HTTPMethodRequest: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case patch = "PATCH"
}

enum ServicesStatus: Int {
    case notAssigned
    case undefined
    case successful
    case failConnection
    case failValidation
    case failAuthentication
    case serverError
    case notFound
    case failParser
    case gatewayTimeout
    case none
    case handledError
    case gone
    case noContent
    case conflict
    case forbidden
    case badRequest = 400
}

struct RequestError: Error {
    var defaultMessage: String = ""
    var statusError: ServicesStatus = .none
    
    init(status: ServicesStatus) {
        statusError = status
    }
}

class Request: NSObject {
    func makeRequestWith<T: Decodable>(_ method: HTTPMethodRequest,
                                       model: T.Type,
                                       endPoint: String,
                                       params: [String: Any] = [:],
                                       onSuccess: @escaping (T) -> Void,
                                       onError: @escaping (Error) -> Void) {
        guard let url = internetConnectionAndURL(onError: onError,
                                                 endPoint: endPoint) else {
            return
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url, timeoutInterval: 20)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = (method == HTTPMethodRequest.get || params.isEmpty) ? nil : jsonData
        request.timeoutInterval = 20
        
        debugPrint("endPoint: \(endPoint)")
        debugPrint("body: \(params)")
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else {
                onError(RequestError(status: .noContent))
                return
            }
            guard error == nil,
                  let dataRequest = data, !dataRequest.isEmpty else {
                self.statusCodeHTTP(model: model, response: response, onSuccess: onSuccess, onError: onError)
                return
            }
            self.analizeResponse(dataRequest: dataRequest, model: model,
                                 response: response, onSuccess: onSuccess,
                                 onError: onError)
        }.resume()
    }
    
    fileprivate func analizeResponse<T: Decodable>(dataRequest: Data,
                                                   model: T.Type,
                                                   response: URLResponse?,
                                                   onSuccess: @escaping (T) -> Void,
                                                   onError: @escaping (Error) -> Void,
                                                   extraInfo: Any? = nil) {
        do {
            guard let httpResponse = response as? HTTPURLResponse else {
                onError(RequestError(status: .serverError))
                return
            }
            guard let json = try JSONSerialization.jsonObject(with: dataRequest, options: .allowFragments) as? JSON else {
                if let jsonObj = try? JSONSerialization.jsonObject(with: dataRequest, options: JSONSerialization.ReadingOptions()) as? [Any] {
                    debugPrint("JSON RESPONSE:")
                    dump(jsonObj)
                    self.parseData(jsonObj, model: model, data: dataRequest,
                                   onSuccess, onError, httpResponse.statusCode,
                                   extraInfo: extraInfo)
                    return
                }
                onError(RequestError(status: .failParser))
                return
            }
            debugPrint("JSON RESPONSE:")
            dump(json)
            self.parseData(json, model: model, data: dataRequest, onSuccess,
                           onError, httpResponse.statusCode, extraInfo: extraInfo)
        } catch let error {
            onError(error)
        }
    }
    
    fileprivate func internetConnectionAndURL(onError: @escaping (Error) -> Void,
                                              endPoint: String) -> URL? {
        guard let url = URL(string: endPoint) else {
            onError(RequestError(status: .noContent))
            return nil
        }
        return url
    }
    
    fileprivate func checkErrorInJSON(json: JSON?) -> Error? {
        if let statusCode = json?["statusCode"] as? Int, statusCode != 200 {
            var error = RequestError(status: ServicesStatus(rawValue: statusCode) ?? .none)
            error.defaultMessage = json?["message"] as? String ?? ""
            return error
        }
        return nil
    }
    
    fileprivate func parseData<T: Decodable>(_ json: Any, model: T.Type, data: Data,
                                             _ successRequest: @escaping (T) -> Void,
                                             _ onError: @escaping (Error) -> Void,
                                             _ statusCode: Int, extraInfo: Any? = nil) {
        if let jsonObj = json as? JSON,
           let code = jsonObj["status"] as? String,
           code != "OK", statusCode != 200 {
            onError(RequestError(status: .noContent))
            return
        }
        commonParsing(dataObj: data, model: model,
                      onSuccess: successRequest, onError: onError)
    }
    
    fileprivate func commonParsing<T: Decodable>(dataObj: Data, model: T.Type,
                                                 onSuccess: @escaping (T) -> Void,
                                                 onError: @escaping (Error) -> Void) {
        do {
            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.useDefaultKeys
            let results: T = try decoder.decode(model.self,
                                                from: dataObj)
            onSuccess(results)
        } catch let error {
            onError(error)
        }
    }
    
    fileprivate func statusCodeHTTP<T: Decodable>(model: T.Type,
                                                  response: URLResponse?,
                                                  onSuccess: @escaping (T) -> Void,
                                                  onError: @escaping (Error) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 || httpResponse.statusCode == 200 else {
            onError(RequestError(status: .serverError))
            return
        }
        let jsonString = "[{}]"
        let jsonData = Data(jsonString.utf8)
        commonParsing(dataObj: jsonData, model: model, onSuccess: onSuccess, onError: onError)
    }
}
