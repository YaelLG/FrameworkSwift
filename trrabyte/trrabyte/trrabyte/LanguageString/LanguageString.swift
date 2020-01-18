//
//  LanguageString.swift
//  Zygoo
//
//  Created by Diego Luna on 10/14/19.
//  Copyright © 2019 Terrabyte. All rights reserved.
//

import Foundation
import UIKit

enum LanguageString: String {
       
    case appName
    case empty
    case notHandled
    case alert
    
    //Advertisements
    case notDataAvailable
    case advertisementSaveData
    case advertisementMatchData
    case alertDate
    case alertHour
    case alertNoHear
    case alertDataNeedsClient
    case alertEmailSent
    case alertOpenEmail
    case alertRequest
    case alertNoEmail
    case alertNoPhone
    case alertNoPassword
    case alertNoAnswer
    case alertNoQuestion
    case alertNoRelatedPassword
    case alertNoName
    case alertNoRelation
    case alertNoSurnames
    case alertNoCURP
    case alertDateBirth
    case alertNoPlace
    case alertNoSuburb
    case alertNoStreet
    case alertNoNumber
    case alertNoCP
    case alertNoPercentage
    case alertNoState
    case alertNoDelegation
    case alertNoCountry
    case alertNoValidEmail
    case alertNoValidPhone
    case alertNoMatchEmail
    case alertNoValidCountry
    case alertNoValidCURP
    case alertEmailConfirmation
    
    //Sections
    case registerSection
    case comissionSection
    case loginSection
    
    //General
    case initSession
    case aplication
    case description
    case cameraError
    case defaultDropdown
    case yes
    case no
    case ok
    case IFECodeDesc
    
    //UserDefaults
    case userAllDefaults
    case userEmailDefaults
    case userPhoneDefaults
    case userPasswordDefaults
    case userSecretQuestionDefaults
    case userSecretAnswerDefaults
    case userNameDefaults
    case userSurnameDefaults
    case userIsWholeRegisterDefaults
    case userTermsDefaults
    case userNacionalityDefaults
    case userStreetDefaults
    case userNumberDefaults
    case userNumberIntDefaults
    case userCPDefaults
    case userCountryDefaults
    case userDelegationDefaults
    case userStateDefaults
    case userSuburbDefaults
    
    case userBeneficiaryDefaults
    case userPercentageDefaults

    //Segues
    case logSegue
    case registerSegue
    case mainSegue
    case homeSegue
    case comisionSegue
    case phoneSegue
    case OCRSegue
    case termsSegue
    case infoSegue
    case detailSegue
    case beneficiarySegue
    case endSegue
    
    //Placeholders
    case commentPlaceholder
    case descPlaceholder
    case amountPlaceholder
    case phonePlaceholder
    case addressPlaceholder
    case datePlaceholder
    case hourPlaceholder
    
    // SideMenu
    case servicePay
    case cellPhoneMinutes
    case transfer
    case howToHelp

    var localized: String {
        return localize()
    }
}

private extension LanguageString {
    
    func localize() -> String
    {
        return NSLocalizedString(rawValue, tableName: "Localizable", bundle: .main, value: "", comment: "")
    }
}
