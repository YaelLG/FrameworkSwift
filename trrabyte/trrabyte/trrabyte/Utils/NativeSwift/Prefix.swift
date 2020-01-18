//
//  Prefix.swift
//  SearchBar
//
//

import Foundation
import UIKit

public typealias JSON = [String : Any]
public typealias JSONData = Data
public typealias JSONString = String
public typealias CabRequest = [String : Dictionary<String, Any>]

private var serviceURL = ""

enum serviceNames
{
    case serviceTypeLogin(pathsLogin)
    
    var serviceType: serviceType {
        switch self {
        case .serviceTypeLogin(let path):
            serviceURL = path.rawValue
            return .serviceTypeLogin
        }
    }
}

enum pathsLogin: String {
    case startRegister = "IniciarRegistro"
    case getConfig = "ObtenerConfiguraciones"
    case getEmployee = "ObtenerEmpleado"
}

enum serviceType: String
{
    case serviceTypeLogin = "Login"
}

enum enviromentType: String
{
    case enviromentTypeProduccion = "Produccion"
    case enviromentTypeStaging = "Staging"
    case enviromentTypeNoValue = "NoValue"
}

//MARK: - Declaracion tamaños

var screenSize : CGRect {
    get{
        return UIScreen.main.bounds
    }
}

//MARK: - UserDefaults

let tutorialDefs : String = "tutorialDefs"

//MARK: - Servicios

func getServiceForSection(enviroment : enviromentType, serviceName : serviceNames) -> String
{
    if let path = Bundle.main.path(forResource: "Enviroments", ofType: "plist"), let dic = NSDictionary(contentsOfFile: path) as? [String: Any]
    {
        for (_ , element) in dic.enumerated()
        {
            var enviromentPredefined : enviromentType = .enviromentTypeNoValue
            
            if element.value as? Bool ?? false && element.key == "Produccion"
            {
                enviromentPredefined = .enviromentTypeProduccion
            }else if element.value as? Bool ?? false && element.key == "Staging"
            {
                enviromentPredefined = .enviromentTypeStaging
            }
            
            if enviromentPredefined != .enviromentTypeNoValue
            {
                if let sectionDic = dic[serviceName.serviceType.rawValue] as? [String : Any], let url = sectionDic[enviromentPredefined.rawValue] as? String
                {
                    return url
                }
            }
        }
        
        if let sectionDic = dic[serviceName.serviceType.rawValue] as? [String : Any], let dictPaths = sectionDic[serviceURL] as? [String : Any], let url = dictPaths[enviroment.rawValue] as? String
        {
            return url
        }
    }
    
    return ""
}



