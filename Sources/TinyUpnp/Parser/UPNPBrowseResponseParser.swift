//
//  UPNPBrowseResponseParser.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 08.11.20.
//

import Foundation
import os


/// This class is used to parse the browse response. As the content of the xml file contains nested XML its parsing is split up into two seperate parsers
public class UPNPBrowseResponseParser {
    
    
    public typealias CompletionHandler = (Result<CDSBrowseResponse, Error>) -> Void
    
    fileprivate var completionHandler: CompletionHandler?
    fileprivate var baseParser: UPNPBrowseResponseOuterStructureParser?
    fileprivate var didlLiteParser: UPNPBrowseResponseDIDLLiteParser?
    

    public func parse(data: Data, then handler: @escaping CompletionHandler) {
        completionHandler = handler
        
        if let stringData = String(data: data, encoding: .utf8) {
            os_log(.debug, "passed data %s", stringData )
        }
 
        parseBaseData(data)
    }
}


// MARK: - Private method
fileprivate extension UPNPBrowseResponseParser {
    

    func parseBaseData(_ data: Data) {
        
        baseParser = UPNPBrowseResponseOuterStructureParser()
        baseParser?.parse(data: data, then: { [weak self] result in
            
            switch result {
            case .success(let baseResponseData):
            
                guard let resultString = baseResponseData.resultString,
                      let innerDIDLData = baseResponseData.resultString?.data(using: .utf8) else {
                    return
                }

                
                self?.parseDIDLLiteDate(innerDIDLData, on: { didlResult in
                    
                    guard let completionHandler = self?.completionHandler else {
                        return
                    }
                    
                    switch didlResult {
                    case .success(let objects):
                        let browseResponse = CDSBrowseResponse(numberReturned: baseResponseData.numberReturned,
                                                               totalMatches: baseResponseData.totalMatches,
                                                               updatedId: baseResponseData.updatedId,
                                                               result: objects)
                        
                        completionHandler(.success(browseResponse))
                        
                    case .failure(let error):
                        completionHandler(.failure(error))
                    
                    }
   
                })
                
                
            case .failure(let error):
                os_log(.error, "error %@", error.localizedDescription)

            }
            
        })
        
    }
    
    
    func parseDIDLLiteDate(_ data: Data, on completion: @escaping (Result<[CDSBaseObject], Error>) -> Void) {
        
        didlLiteParser = UPNPBrowseResponseDIDLLiteParser()
        didlLiteParser?.parse(data: data, then: { parseResult in
            
            switch parseResult {
            case .success(let responseData):
                completion(.success(responseData.objects))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}
