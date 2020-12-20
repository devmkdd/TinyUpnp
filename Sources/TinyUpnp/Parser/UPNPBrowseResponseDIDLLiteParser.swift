//
//  UPNPCDSDIDLLiteParser.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 08.11.20.
//

import Foundation
import os


internal struct CDSBrowseResponseDIDLResult {
    let objects: [CDSBaseObject]
    
}

internal class UPNPBrowseResponseDIDLLiteParser: NSObject {
    
    typealias CompletionHandler = (Result<CDSBrowseResponseDIDLResult, Error>) -> Void
    fileprivate var completionHandler: CompletionHandler?
    fileprivate var result: CDSBrowseResponseDIDLResult?
    
    fileprivate var parsedItems = [CDSBaseObject]()
    
    
    private var xmlparser: XMLParser?
    
    
    fileprivate var currentString: String = ""
    
    fileprivate var dictCurrentContainer = [CDSContainerValueKey: String]()
    fileprivate var dictCurrentItem = [CDSItemValueKey: String]()
    fileprivate var dictCurrentResourceEntry = [CDSResourceValueKey: Any]()
    fileprivate var resources = [CDSResource]()
    
    /// Temporary array where all album art uris stored as string
    fileprivate var albumArtUris = [String]()
    
    
    fileprivate var currentParsedElement: DIDLLiteObjectType?
    fileprivate var handlingComposer: Bool = false
    
    fileprivate var response: CDSBrowseResponse?
    
    func parse(data: Data, then handler: @escaping CompletionHandler) {
        completionHandler = handler
        xmlparser = XMLParser(data: data)
        xmlparser?.delegate = self
        xmlparser?.parse()
        xmlparser?.delegate = nil
        
        if let completionHandler = completionHandler {
            completionHandler(.success(CDSBrowseResponseDIDLResult(objects: parsedItems)))
        }
    }
}


// MARK: - XMLParserDelegate
extension UPNPBrowseResponseDIDLLiteParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        
        currentString = ""
        
        if elementName == DIDLLiteObjectType.container.rawValue {
            dictCurrentContainer.removeAll()
            currentParsedElement = .container
            
            handleAttributesForContainer(attributeDict: attributeDict)
            return
        }
        
        if elementName == DIDLLiteObjectType.item.rawValue {
            dictCurrentItem.removeAll()
            currentParsedElement = .item
            
            handleAttributesForItem(attributeDict: attributeDict)
            return
        }
        
        if elementName == "res" {
            dictCurrentResourceEntry.removeAll()
            
            handleAttributesForRessource(attributeDict: attributeDict)
            return
        }
        
        if elementName == "upnp:artist",
           attributeDict["role"] == "Composer" {
            handlingComposer = true
        }
        
        if elementName == CDSItemValueKey.albumArtURI.rawValue {
            albumArtUris.removeAll()
        }
    }
        
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString += string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        os_log(.info, "didEndElement %s", elementName)
        
        
        switch elementName {
        
        
        case DIDLLiteObjectType.container.rawValue:
            
            guard let container = containerFromDictionary(dictCurrentContainer) else {
                return
            }
            
            os_log(.debug, "container: %s", container.description)
            parsedItems.append(container)
            
            dictCurrentContainer.removeAll()
            resources.removeAll()
            
        case DIDLLiteObjectType.item.rawValue:
            
            guard let item = itemFromDictionary(dictCurrentItem) else {
                return
            }
            
            os_log(.debug, "item: %s", item.description)
            parsedItems.append(item)
            resources.removeAll()
            
            dictCurrentContainer.removeAll()
            
        case "res":
            if let resource = parseResource(from: dictCurrentResourceEntry) {
                resources.append(resource)
            }
            dictCurrentResourceEntry.removeAll()
            
        default:
            
            if currentParsedElement == DIDLLiteObjectType.container,
               CDSContainerValueKey.isValidValue(stringValue: elementName),
               let containerKey = CDSContainerValueKey.init(rawValue: elementName) {
                dictCurrentContainer[containerKey] = currentString
                return
            }
            
            
            if currentParsedElement == DIDLLiteObjectType.item,
               CDSItemValueKey.isValidValue(stringValue: elementName),
               let containerKey = CDSItemValueKey.init(rawValue: elementName) {
                
                if handlingComposer {
                    dictCurrentItem[.composer] = currentString
                    handlingComposer = false
                    return
                }
                
                if containerKey == .albumArtURI {
                    albumArtUris.append(currentString)
                    return
                }
                
                dictCurrentItem[containerKey] = currentString
                return
            }
        }
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
}


// MARK: - Private helper methods
fileprivate extension UPNPBrowseResponseDIDLLiteParser {
    
    
    // helper method to create a ressource out of the parsedDict
    func parseResource(from resourceDict: [CDSResourceValueKey: Any]) -> CDSResource? {
        
        guard let protocolInfo = resourceDict[.protocolInfo] as? String else {
            return nil
        }
        
        let uri = currentString
        
        var resource = CDSResource(uri: uri, protocolInfo: protocolInfo)
        resource.importUri = resourceDict[.importUri] as? String
        resource.size = resourceDict[.size] as? UInt
        resource.duration = resourceDict[.duration] as? String
        resource.bitrate = resourceDict[.bitrate] as? UInt
        resource.sampleFrequency = resourceDict[.bitrate] as? UInt
        resource.bitsPerSample = resourceDict[.bitsPerSample] as? UInt
        resource.nrAudioChannels = resourceDict[.nrAudioChannels] as? UInt
        resource.resolution = resourceDict[.resolution] as? String
        resource.protection = resourceDict[.protection] as? String
        resource.colorDepth = resourceDict[.colorDepth] as? UInt
        
        return resource
    }
    
    
    func handleAttributesForRessource(attributeDict: [String: String]) {
        
        for key in attributeDict.keys {
            
            if CDSResourceValueKey.isValidValue(stringValue: key),
               let containerKey = CDSResourceValueKey.init(rawValue: key) {
                dictCurrentResourceEntry[containerKey] = attributeDict[key]
            }
        }
    }
    
    
    func handleAttributesForItem(attributeDict: [String: String]) {
        
        for key in attributeDict.keys {
            
            if CDSItemValueKey.isValidValue(stringValue: key),
               let containerKey = CDSItemValueKey.init(rawValue: key) {
                dictCurrentItem[containerKey] = attributeDict[key]
            }
        }
    }
    
    
    func handleAttributesForContainer(attributeDict: [String: String]) {
        
        for key in attributeDict.keys {
            
            if CDSContainerValueKey.isValidValue(stringValue: key),
               let containerKey = CDSContainerValueKey.init(rawValue: key) {
                dictCurrentContainer[containerKey] = attributeDict[key]
            }
        }
    }
    
    
    /// Helper method to construct the container out of the passed dictionary
    func containerFromDictionary(_ dict: [CDSContainerValueKey: String]) -> CDSContainerObject? {
        
        guard let title = dict[.title],
              let containerId = dict[.id],
              let parentId = dict[.parentID],
              let restrictedStr = dict[.restricted],
              let classDefinition = dict[.classDefinition] else {
            return nil
        }
        let restricted = (restrictedStr as NSString).boolValue
        let searchable = (dict[.searchable] as NSString?)?.boolValue
        
        var container = CDSContainerObject(classDefinition: classDefinition,
                                           id: containerId,
                                           writeStatus: nil,
                                           parentID: parentId,
                                           title: title,
                                           creator: nil,
                                           restricted: restricted,
                                           searchable: searchable,
                                           resources: resources)
        
        if let stringChildCount = dict[.childCount] {
            container.childCount = Int((stringChildCount as NSString).intValue)
        }
        
        if let stringModificationTime = dict[.modificationTime] {
            container.modificationTime = Double((stringModificationTime as NSString).doubleValue)
        }
        
        return container
    }
    
    
    /// Helper method to construct the item out of the passed dictionary

    func itemFromDictionary(_ dict: [CDSItemValueKey: String]) -> CDSItemObject? {
        
        guard let title = dict[.title],
              let itemId = dict[.id],
              let parentId = dict[.parentID],
              let restrictedStr = dict[.restricted],
              let classDefinition = dict[.classDefinition] else {
            return nil
        }
        
        let restricted = (restrictedStr as NSString).boolValue
        var item = CDSItemObject(classDefinition: classDefinition,
                                 resources: resources,
                                 parentID: parentId,
                                 id: itemId,
                                 writeStatus: nil,
                                 title: title,
                                 creator: nil,
                                 restricted: restricted)
        
        item.album = dict[.album]
        item.artist = dict[.artist]
        item.albumArtist = dict[.albumArtist]
        item.albumArtURIs = albumArtUris
        item.genre = dict[.genre]
        item.composer = dict[.composer]
        
        if let trackNumberInt = (dict[.originalTrackNumber] as NSString?)?.integerValue {
            item.originalTrackNumber = UInt(trackNumberInt)
        }
        
        if let stringModificationTime = dict[.modificationTime] {
            item.modificationTime = Double((stringModificationTime as NSString).doubleValue)
        }
        
        
        item.creator = dict[.creator]
        
        return item
        
    }
}


// MARK: - Internal helper classes


fileprivate enum CDSContainerValueKey: String, CaseIterable {
    
    // swiftlint:disable identifier_name
    // -> disbled to match property name of the defined standard
    case id = "id"
    case parentID = "parentID"
    case title = "dc:title"
    case creator = "creator"
    case restricted = "restricted"
    case writeStatus = "writeStatus"
    case searchable = "searchable"
    case classDefinition = "upnp:class"
    case childCount = "childCount"
    case modificationTime = "pv:modificationTime"
    
    static func isValidValue(stringValue: String) -> Bool {
        
        let possibleValues: [String] = CDSContainerValueKey.allCases.map { $0.rawValue }
        return possibleValues.contains(stringValue)
        
    }
}


fileprivate enum CDSItemValueKey: String, CaseIterable {
    
    // swiftlint:disable identifier_name
    // -> disbled to match property name of the defined standard
    case id = "id"
    case parentID = "parentID"
    case album = "upnp:album"
    case artist = "upnp:artist"
    case albumArtist = "upnp:albumArtist"
    case title = "dc:title"
    case genre = "upnp:genre"
    case originalTrackNumber = "upnp:originalTrackNumber"
    case fileExtension = "pv:extension"
    
    /// The albumArtUris contains a reference to album art. The value shall be a properly escaped URI and may occure multiple times within an item
    case albumArtURI = "upnp:albumArtURI"
    case creator = "dc:creator"
    case restricted = "restricted"
    case writeStatus = "writeStatus"
    case searchable = "searchable"
    case composer = "composer"
    case resources = "res"
    case classDefinition = "upnp:class"
    case modificationTime = "pv:modificationTime"
    
    
    static func isValidValue(stringValue: String) -> Bool {
        
        let possibleValues: [String] = CDSItemValueKey.allCases.map { $0.rawValue }
        return possibleValues.contains(stringValue)
        
    }
}


fileprivate enum CDSResourceValueKey: String, CaseIterable {
    case uri
    case importUri
    case protocolInfo
    case size
    case duration
    case bitrate
    case sampleFrequency
    case bitsPerSample
    case nrAudioChannels
    case resolution
    case colorDepth
    case protection
    
    static func isValidValue(stringValue: String) -> Bool {
        
        let possibleValues: [String] = CDSResourceValueKey.allCases.map { $0.rawValue }
        return possibleValues.contains(stringValue)
        
    }
}


fileprivate enum DIDLLiteObjectType: String {
    case container
    case item
}
