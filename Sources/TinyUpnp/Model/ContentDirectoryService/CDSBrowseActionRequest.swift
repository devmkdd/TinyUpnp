//
//  CdsBrowseAction.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 07.11.20.
//

import Foundation


public enum CdsBrowseFlag: String {
    case BrowseDirectChildren
    case BrowseMetadata
}

/// This struct describes a browse action on a content directory service containing the input properties for querying the service
public struct CDSBrowseActionRequest {
    
    // ObjectID parameters uniquely identify individual objects within the Content Directory Service.
    public var objectId: String
    public var browseFlag: CdsBrowseFlag
    public var filter: String
    public var startingIndex: UInt
    public var requestedCount: UInt
    public var sortCriteria: String
    
    public init(objectId: String = "0",
         browseFlag: CdsBrowseFlag = .BrowseDirectChildren,
         filter: String = "*",
         startingIndex: UInt = 0,
         requestedCount: UInt = 0,
         sortCriteria: String = "0") {
        
        self.objectId = objectId
        self.browseFlag = browseFlag
        self.filter = filter
        self.startingIndex = startingIndex
        self.requestedCount = requestedCount
        self.sortCriteria = sortCriteria
    }
}
