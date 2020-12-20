//
//  CDSBaseObject.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 09.11.20.
//

import Foundation


public enum CDSWriteStatusValue: String {
    case mixed = "MIXED"
    case protected = "PROTECTED"
    case notWritable = "NOT_WRITABLE"
    case unknown = "UNKNOWN"
    case writeable = "WRITABLE"
    
}


public protocol CDSBaseObject {
    
    // swiftlint:disable identifier_name
    // -> disbled to match property name of the defined standard
    /// An unique identifier for the object with respect to the Content Directory.
    var id: String { get set }
    
    /// id property of object’s parent. The parentID of the Content Directory ‘root’ container must be set to the reserved value of “-1”. No other parentID attribute of any other Content Directory object may take this value.
    var parentID: String { get set }
    
    /// Name of the object
    var title: String { get set }
    
    /// Primary content creator or owner of the object
    var creator: String? { get set }
    
    /// Resource, typically a media file, associated with the object. Values must be properly escaped URIs as described in [RFC 2396].
    var resources: [CDSResource]? { get set }
    
    /// When true, ability to modify a given object is confined to the Content Directory Service. Control point metadata write access is disabled.
    var restricted: Bool { get set }
    
    /// When present, controls the modifiability of the resources of a given object. Ability of a Control Point to change writeStatus of a given resource(s) is implementation dependent.
    var writeStatus: CDSWriteStatusValue? { get set }
    
    ///
    var classDefinition: String { get set}
    
    /// The modification time of the object (on disc) in Unix time
    var modificationTime: TimeInterval? { get set }
    
}
