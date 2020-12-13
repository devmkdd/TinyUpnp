//
//  CDSBrowseResponse.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 08.11.20.
//

import Foundation


/// This object represants the response of a browse action on the content directory service
public struct CDSBrowseResponse {
    
    public let numberReturned: UInt
    public let totalMatches: UInt
    public let updatedId: UInt
    public let result: [CDSBaseObject]
}


// MARK: - CustomStringConvertible
extension CDSBrowseResponse: CustomStringConvertible {
    
    public var description: String {
        
        return "CDSBrowseResponse\n" +
        " numberReturned: \(numberReturned)\n" +
        " totalMatches: \(totalMatches)\n" +
        " updatedId: \(updatedId)\n" +
        " result: \(result)\n"
    }
    
}
