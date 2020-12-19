//
//  UPNPService.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 06.11.20.
//

import Foundation

public struct UPNPService {
    public let serviceType: String
    public let serviceId: String
    public let scpdURL: String
    public let eventSubURL: String
    public let controlURL: String
    public var parentDeviceLocation: URL?
    
    
    public func isContentDirectoryService() -> Bool {
        return serviceType == "urn:schemas-upnp-org:service:ContentDirectory:1"
    }
    
    
    public mutating func updateLocation(deviceLocation: URL) {
        
        if self.parentDeviceLocation != nil {
            // don't update if it already has a location
            return
        }
        self.parentDeviceLocation = deviceLocation
    }
}
