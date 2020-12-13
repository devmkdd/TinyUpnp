//
//  CDSContainerObject.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 09.11.20.
//

import Foundation


/// This is a derived class of object used to represent containers e.g. a music album. The XML expression of any instance of a class that is derived from container is the <container> tag. The container class identifies the properties specified on its base class object, as well as dditional properties
public struct CDSContainerObject: CDSBaseObject {
 
    public var modificationTime: TimeInterval?
    
    public var classDefinition: String
        
    public var id: String
    public var writeStatus: CDSWriteStatusValue?
    public var parentID: String
    public var title: String
    public var creator: String?
    public var restricted: Bool
    public var searchable: Bool?
    public var resources: [CDSResource]?
    
    /// Child count for the object
    public var childCount: Int?
       
}


// MARK: - CustomStringConvertible
extension CDSContainerObject: CustomStringConvertible {
    
    public var description: String {
        
        return "CDSContainerObject\n" +
            " id: \(id)\n" +
            " parentID: \(parentID)\n" +
            " title: \(String(describing: title))\n" +
            " childCount: \(String(describing: childCount))\n" +
            " restricted: \(restricted)\n" +
            " searchable: \(String(describing: searchable))\n" +
            " creator: \(String(describing: creator))\n" +
            " modificationTime: \(String(describing: modificationTime))\n" +
            " resources: \(String(describing: resources))\n"
    }
    
}
