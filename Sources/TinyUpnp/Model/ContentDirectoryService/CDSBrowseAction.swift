//
//  CDSBrowsAction.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 14.11.20.
//

import Foundation
import os

public class CDSBrowseAction {

    
    public typealias CompletionHandler = (Result<CDSBrowseResponse, Error>) -> Void
    
    fileprivate var completionHandler: CompletionHandler?
    
    
    public init(){}
    
    
    public func run(request: CDSBrowseActionRequest,
             on contentDirectoryService: UPNPService,
             then handler: @escaping CompletionHandler) {
        completionHandler = handler
        
        
        guard var baseUrl = contentDirectoryService.parentDeviceLocation else {
            return
        }
        
        baseUrl = baseUrl.appendingPathComponent(contentDirectoryService.controlURL)
        
        
        var urlRequest = URLRequest(url: baseUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("\"urn:schemas-upnp-org:service:ContentDirectory:1#Browse\"", forHTTPHeaderField: "SOAPACTION")
        
        
        var requestBody = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
        requestBody.append("<s:Body><u:Browse xmlns:u=\"\(contentDirectoryService.serviceType)\">")
        requestBody.append("<ObjectID>\(request.objectId)</ObjectID>")
        requestBody.append("<BrowseFlag>\(request.browseFlag.rawValue)</BrowseFlag>")
        requestBody.append("<Filter>\(request.filter)</Filter>")
        requestBody.append("<StartingIndex>\(request.startingIndex)</StartingIndex>")
        requestBody.append("<RequestedCount>\(request.requestedCount)</RequestedCount>")
        requestBody.append("<SortCriteria>\(request.sortCriteria)</SortCriteria>")
        requestBody.append("</u:Browse></s:Body></s:Envelope>")
        /*
        let requestBody = "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:Browse xmlns:u=\"urn:schemas-upnp-org:service:ContentDirectory:1\"><ObjectID>0</ObjectID><BrowseFlag>BrowseDirectChildren</BrowseFlag><Filter>*</Filter><StartingIndex>0</StartingIndex><RequestedCount>0</RequestedCount><SortCriteria>0</SortCriteria></u:Browse></s:Body></s:Envelope>"
        */
        
        urlRequest.httpBody = requestBody.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest)  { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
                        
            let parser = UPNPBrowseResponseParser()
            parser.parse(data: data) { [weak self] (result) in
                
                guard let completionHandler = self?.completionHandler else {
                    return
                }
                
                completionHandler(result)
            }
        }
        
        task.resume()
        
    }
}
