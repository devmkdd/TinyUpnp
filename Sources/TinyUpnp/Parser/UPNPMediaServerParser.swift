//
//  UPNPMediaServerParser.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 03.11.20.
//

import Foundation
import os


public class UPNPMediaServerParser: NSObject {
    
    private var xmlparser: XMLParser?
    
    fileprivate var dictDevice = [UPNPDeviceValueKey: String]()
    fileprivate var dictService = [UPNPServiceValueKey: String]()
    fileprivate var services = [UPNPService]()
    fileprivate var currentString: String = ""
    
    public typealias CompletionHandler = (Result<UPNPDevice, Error>) -> Void
    var completionHandler: CompletionHandler?
    
    fileprivate var device: UPNPDevice?
    
    public func parse(data: Data, then handler: @escaping CompletionHandler) {
        completionHandler = handler
        xmlparser = XMLParser(data: data)
        xmlparser?.delegate = self
        xmlparser?.parse()
        xmlparser?.delegate = nil
        
        guard let completion = completionHandler else {
            return
        }
        
        guard let device = device else {
            completion(.failure(ParsingError()))
            return
        }
        
        completion(.success(device))
        
    }
}


// MARK: - XMLParserDelegate
extension UPNPMediaServerParser: XMLParserDelegate {
    
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentString = ""
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString += string
    }

    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if UPNPDeviceValueKey.isValidValue(stringValue: elementName),
           let deviceKey = UPNPDeviceValueKey.init(rawValue: elementName) {
            dictDevice[deviceKey] = currentString
            return
        }
        
        if UPNPServiceValueKey.isValidValue(stringValue: elementName),
           let serviceKey = UPNPServiceValueKey.init(rawValue: elementName) {
            dictService[serviceKey] = currentString
            return
        }
        
        switch elementName {
        
        
        case "device":
            device = deviceFromDict(deviceDict: dictDevice, services: services)
            os_log(.debug, "device: %@", self.device.debugDescription)
        case "service":
            guard let service = serviceFromDict(serviceDict: dictService) else {
                return
            }
            
            services.append(service)
            dictService.removeAll()
            
        default:
            break
            
        }
    }
        
}


class ParsingError: Error {}

// MARK: - Private Parsing helpers
extension UPNPMediaServerParser {
    
    fileprivate func serviceFromDict(serviceDict: [UPNPServiceValueKey: String]) -> UPNPService? {
        
        guard let serviceType = serviceDict[.serviceType],
              let serviceId = serviceDict[.serviceId],
              let scdpURL = serviceDict[.scpdURL],
              let eventSubURL = serviceDict[.eventSubURL],
              let controlURL = serviceDict[.controlURL] else {
            return nil
        }
        
        return UPNPService(serviceType: serviceType, serviceId: serviceId, scpdURL: scdpURL, eventSubURL: eventSubURL, controlURL: controlURL)
    }
    
    
    fileprivate func deviceFromDict(deviceDict: [UPNPDeviceValueKey: String], services: [UPNPService]) -> UPNPDevice? {
        
        guard let deviceType = dictDevice[.deviceType],
              let friendlyName = dictDevice[.friendlyName]  else {
            return nil
        }
        
        return UPNPDevice(deviceType: deviceType,
                          friendlyName: friendlyName,
                          manufacturerName: dictDevice[.manufacturerName],
                          manufacturerURL: dictDevice[.manufacturerURL],
                          modelDescription: dictDevice[.modelDescription],
                          modelName: dictDevice[.modelName],
                          modelNumber: dictDevice[.modelNumber],
                          modelURL: dictDevice[.modelURL],
                          serialNumber: dictDevice[.serialNumber],
                          udn: dictDevice[.udn],
                          upc: dictDevice[.upc],
                          serviceList: services)
    }
}


fileprivate enum UPNPDeviceValueKey: String, CaseIterable {
    case deviceType = "deviceType"
    case friendlyName = "friendlyName"
    case manufacturerName = "manufacturer"
    case manufacturerURL = "manufacturerURL"
    case modelDescription = "modelDescription"
    case modelName = "modelName"
    case modelNumber = "modelNumber"
    case modelURL = "modelURL"
    case serialNumber = "serialNumber"
    case udn = "UDN"
    case upc = "UPC"
    
    
    static func isValidValue(stringValue: String) -> Bool {
        
        let possibleValues: [String] = UPNPDeviceValueKey.allCases.map { $0.rawValue }
        return possibleValues.contains(stringValue)
        
    }
}


fileprivate enum UPNPServiceValueKey: String, CaseIterable {
    case serviceType = "serviceType"
    case serviceId = "serviceId"
    case scpdURL = "SCPDURL"
    case controlURL = "controlURL"
    case eventSubURL = "eventSubURL"
    
    static func isValidValue(stringValue: String) -> Bool {
        
        let possibleValues: [String] = UPNPServiceValueKey.allCases.map { $0.rawValue }
        return possibleValues.contains(stringValue)
        
    }
    
}
