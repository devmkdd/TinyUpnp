//
//  UPNPCDSDIDLLiteParser.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 08.11.20.
//

import Foundation
import os


struct CDSBrowseResponseDIDLResult {
    let objects: [CDSBaseObject]
    
}

class UPNPBrowseResponseDIDLLiteParser: NSObject {
    
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
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentString = ""
        
        if elementName == DIDLLiteObjectType.container.rawValue {
            dictCurrentContainer.removeAll()
            currentParsedElement = .container
            
            for key in attributeDict.keys {
                
                if CDSContainerValueKey.isValidValue(stringValue: key),
                   let containerKey = CDSContainerValueKey.init(rawValue: key) {
                    dictCurrentContainer[containerKey] = attributeDict[key]
                }
            }
            
            return
        }
        
        if elementName == DIDLLiteObjectType.item.rawValue {
            dictCurrentItem.removeAll()
            currentParsedElement = .item
            
            for key in attributeDict.keys {
                
                if CDSItemValueKey.isValidValue(stringValue: key),
                   let containerKey = CDSItemValueKey.init(rawValue: key) {
                    dictCurrentItem[containerKey] = attributeDict[key]
                }
            }
            
            return
        }
        
        if elementName == "res" {
            dictCurrentResourceEntry.removeAll()
            
            for key in attributeDict.keys {
                
                if CDSResourceValueKey.isValidValue(stringValue: key),
                   let containerKey = CDSResourceValueKey.init(rawValue: key) {
                    dictCurrentResourceEntry[containerKey] = attributeDict[key]
                }
            }
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
            
            guard let protocolInfo = dictCurrentResourceEntry[.protocolInfo] as? String else {
                return
            }
            
            let uri = currentString
            
            
            var resource = CDSResource(uri: uri, protocolInfo: protocolInfo)
            if let importUri = dictCurrentResourceEntry[.importUri] as? String {
                resource.importUri = importUri
            }
            
            if let size = dictCurrentResourceEntry[.size] as? UInt {
                resource.size = size
            }
            
            if let duration = dictCurrentResourceEntry[.duration] as? String {
                resource.duration = duration
            }
            
            if let bitrate = dictCurrentResourceEntry[.bitrate] as? UInt {
                resource.bitrate = bitrate
            }
            
            if let sampleFrequency = dictCurrentResourceEntry[.bitrate] as? UInt {
                resource.sampleFrequency = sampleFrequency
            }
            
            if let bitsPerSample = dictCurrentResourceEntry[.bitsPerSample] as? UInt {
                resource.bitsPerSample = bitsPerSample
            }
            
            if let nrAudioChannels = dictCurrentResourceEntry[.nrAudioChannels] as? UInt {
                resource.nrAudioChannels = nrAudioChannels
            }
            
            if let resolution = dictCurrentResourceEntry[.resolution] as? String {
                resource.resolution = resolution
            }
            
            if let protection = dictCurrentResourceEntry[.protection] as? String {
                resource.protection = protection
            }
            
            if let colorDepth = dictCurrentResourceEntry[.colorDepth] as? UInt {
                resource.colorDepth = colorDepth
            }
            
            resources.append(resource)
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
            break
            
        }
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
}


// MARK: - Private helper methods
fileprivate extension UPNPBrowseResponseDIDLLiteParser {
    
    
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

    func itemFromDictionary(_ dict: [CDSItemValueKey: String]) ->  CDSItemObject? {
        
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
    case uri = "uri"
    case importUri = "importUri"
    case protocolInfo = "protocolInfo"
    case size = "size"
    case duration = "duration"
    case bitrate = "bitrate"
    case sampleFrequency = "sampleFrequency"
    case bitsPerSample = "bitsPerSample"
    case nrAudioChannels = "nrAudioChannels"
    case resolution = "resolution"
    case colorDepth = "colorDepth"
    case protection = "protection"
    
    static func isValidValue(stringValue: String) -> Bool {
        
        let possibleValues: [String] = CDSResourceValueKey.allCases.map { $0.rawValue }
        return possibleValues.contains(stringValue)
        
    }
}


fileprivate enum DIDLLiteObjectType: String {
    case container = "container"
    case item = "item"
}
