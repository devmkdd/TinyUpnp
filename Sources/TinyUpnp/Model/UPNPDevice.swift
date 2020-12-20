//
//  UPnpDevice.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 05.11.20.
//

import Foundation


public struct UPNPDevice {
    public let deviceType: String
    public let friendlyName: String
    public let manufacturerName: String?
    public let manufacturerURL: String?
    public let modelDescription: String?
    public let modelName: String?
    public let modelNumber: String?
    public let modelURL: String?
    public let serialNumber: String?
    
    /// UUID
    public let udn: String?
    public let upc: String?
    public var serviceList: [UPNPService]
    public var location: URL?
    
    
    public func contentDirectoryService() -> UPNPService? {
        
        let contentDirectoryService = serviceList.filter({ $0.serviceType == "urn:schemas-upnp-org:service:ContentDirectory:1" }).first
        return contentDirectoryService
    }
    
    
    public mutating func updateLocation(deviceLocation: URL) {
        
        let baseUrlString = deviceLocation.absoluteString.replacingOccurrences(of: deviceLocation.relativePath, with: "")
        guard let baseUrl = URL(string: baseUrlString) else {
            return
        }
        
        
        if self.location == nil {
            // only update if it already has a location
            self.location = baseUrl
        }

        
        var tempServices = [UPNPService]()
        
        for var service in serviceList {
            service.updateLocation(deviceLocation: baseUrl)
            tempServices.append(service)
        }
        
        self.serviceList = tempServices
        
    }
}


// MARK: - Equatable
extension UPNPDevice: Equatable {

    public static func == (lhs: UPNPDevice, rhs: UPNPDevice) -> Bool {
        return lhs.udn == rhs.udn
    }
    
}
