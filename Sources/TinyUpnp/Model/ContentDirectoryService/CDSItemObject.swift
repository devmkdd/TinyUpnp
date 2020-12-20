//
//  CDSItemObject.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 09.11.20.
//

import Foundation


/// This is a derived class of object used to represent “atomic” content objects, i.e., object that don’t contain other objects,
/// for example, a music track on an audio CD. The XML expression of any instance of a class that is derived from item is the <item> tag.
/// The item class identifies the properties specified on its base class object, as well as the additional properties
public struct CDSItemObject: CDSBaseObject {
    
    public var modificationTime: TimeInterval?
    
    public var classDefinition: String
   
    public var resources: [CDSResource]?
    
    // This array may contain uris for album artworks as string
    public var albumArtURIs: [String]?
        
    public var parentID: String
    
    // swiftlint:disable identifier_name
    // -> disbled to match property name of the defined standard 
    public var id: String
    
    public var writeStatus: CDSWriteStatusValue?
    
  
    public var album: String?
    public var originalTrackNumber: UInt?
    public var artist: String?
    public var composer: String?
    public var albumArtist: String?
    public var genre: String?
    public var title: String
    public var creator: String?
    
    public var restricted: Bool
    

}


// MARK: - CustomStringConvertible
extension CDSItemObject: CustomStringConvertible {
    
    
    public var description: String {
        
        return "CDSItemObject\n" +
            " id: \(id)\n" +
            " parentID: \(parentID)\n" +
            " title: \(title)\n" +
            " restricted: \(restricted)\n" +
            " creator: \(String(describing: creator))\n" +
            " modificationTime: \(String(describing: modificationTime))\n" +
            " resources: \(String(describing: resources))\n"
    }
    
}
