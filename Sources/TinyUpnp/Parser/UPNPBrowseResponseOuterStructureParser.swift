//
//  UPNPBrowseResponseOuterStructureParser.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 08.11.20.
//

import Foundation
import os


public struct CDSBrowseResponseBaseResult {
    public let numberReturned: UInt
    public let totalMatches: UInt
    public let updatedId: UInt
    public let resultString: String?
}

public class UPNPBrowseResponseOuterStructureParser: NSObject {
    
    public typealias CompletionHandler = (Result<CDSBrowseResponseBaseResult, Error>) -> Void
    
    private var resultString: String?
    private var xmlparser: XMLParser?
    private var result: CDSBrowseResponseBaseResult?
    private var numberReturned: UInt = 0
    private var totalMatches: UInt = 0
    private var updatedId: UInt = 0
    
    
    fileprivate var currentString: String = ""
    fileprivate var completionHandler: CompletionHandler?
    
    fileprivate var response: CDSBrowseResponse?
    
    public func parse(data: Data, then handler: @escaping CompletionHandler) {
        completionHandler = handler
     
        xmlparser = XMLParser(data: data)
        xmlparser?.delegate = self
        xmlparser?.parse()
        
        xmlparser?.delegate = nil
        
        guard let resultData = result else {
            return
        }
            
        completionHandler?(.success(resultData))
        
    }
}


// MARK: - XMLParserDelegate
extension UPNPBrowseResponseOuterStructureParser: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentString = ""
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString += string
    }
    
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        os_log(.info, "didEndElement %s", elementName)
        
        if elementName == "Result" {
            os_log(.info, "result:  %@", self.currentString)
            resultString = currentString
            return
        }
        
        if elementName == "NumberReturned" {
            numberReturned = UInt((currentString as NSString).intValue)
            return
        }
        
        if elementName == "TotalMatches" {
            totalMatches = UInt((currentString as NSString).intValue)
            return
        }
        
        if elementName == "UpdateID" {
            updatedId = UInt((currentString as NSString).intValue)
            return
        }
    }
    
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        os_log(.info, "parserDidEndDocument ")
        
        result = CDSBrowseResponseBaseResult(numberReturned: numberReturned,
                                             totalMatches: totalMatches,
                                             updatedId: updatedId,
                                             resultString: resultString)
    }
    
}
