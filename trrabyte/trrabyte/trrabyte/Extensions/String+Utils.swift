//
//  String+Utils.swift
//  Terrabyte
//
//  Created by Diego Yael Luna Gasca on 3/30/20.
//  Copyright © 2020 Terrabyte. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit

public extension String {
    static let formatDate = "MMM dd, yyyy"

    func md5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using: .utf8)!
        var digestData = Data(count: length)
        
        _ = digestData
            .withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
        var md5String = digestData.base64EncodedString()
        md5String.removeAll(where: { $0 == "/"})
        return md5String
    }
    
    func justNumberRemovingSymbols() -> String {
        var phoneCleaned = self.replacingOccurrences(of: " ", with: "")
        phoneCleaned = phoneCleaned.replacingOccurrences(of: "(", with: "")
        phoneCleaned = phoneCleaned.replacingOccurrences(of: ")", with: "")
        phoneCleaned = phoneCleaned.replacingOccurrences(of: "-", with: "")
        return phoneCleaned
    }
    
    func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidCURP() -> Bool {
        let curpRegEx = "^[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[HM]{1}(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$"
        let curpPred = NSPredicate(format:"SELF MATCHES %@", curpRegEx)
        return curpPred.evaluate(with: self)
    }
    
    func isValidDate() -> Bool {
        let dateRegEx = "[0-9]+/[0-9]+/[0-9]{10}"
        
        let datePred = NSPredicate(format: "SELF MATCHES %@", dateRegEx)
        return datePred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        do {
            let pattern = "^(((?=.[a-z])(?=.[A-Z]))|((?=.[a-z])(?=.[0-9]))|((?=.[A-Z])(?=.[0-9])))(?=.{5,})"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidBirthDateFormat() -> Bool {
        let dateRegEx = "[0-9]{2}+/[0-9]{2}+/[0-9]{4}"
        let datePred = NSPredicate(format: "SELF MATCHES %@", dateRegEx)
        return datePred.evaluate(with: self)
    }
    
    func isValidBirthDateFormatScores() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        let date = dateFormatterGet.date(from: self)
        return date.isNull ? false : true
    }
    
    func underlineText() -> NSAttributedString {
        let textRange = NSMakeRange(0, self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        return attributedText
    }
    
    func parseStringToDate(format: String = String.formatDate) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        return date
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func removeAccentsInString() -> String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    func formatphoneNumber(shouldRemoveLastDigit: Bool = false) -> String {
        guard !self.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]",
                                                   options: .caseInsensitive) else { return "" }
        let range = NSString(string: self).range(of: self)
        var number = regex.stringByReplacingMatches(in: self,
                                                    options: .init(rawValue: 0),
                                                    range: range,
                                                    withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<end])
        } else {
            var allowed = CharacterSet()
            allowed.formUnion(.decimalDigits)
            
            let isValidate = number.unicodeScalars.allSatisfy { allowed.contains( $0 ) }
            
            if !isValidate {
                let end = number.index(number.startIndex, offsetBy: number.count - 1)
                number = String(number[number.startIndex..<end])
            }
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)",
                                                 with: "($1) $2",
                                                 options: .regularExpression,
                                                 range: range)
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)",
                                                 with: "($1) $2-$3",
                                                 options: .regularExpression,
                                                 range: range)
        }
        return number
    }

    func getWidthAccordingToFont(margin: CGFloat, height: CGFloat,
                                 font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        let widthScreen = UIScreen.main.bounds.width - 30
        return ceil(min(boundingBox.width, widthScreen)) + margin
    }
    
    func underlineText() -> NSMutableAttributedString {
        let textRange = NSRange(location: 0, length: self.count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        return attributedText
    }
}

public extension NSAttributedString {
    convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension Strideable where Stride: SignedInteger {
    func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
