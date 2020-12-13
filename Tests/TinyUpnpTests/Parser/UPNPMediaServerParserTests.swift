//
//  SSDPTestTests.swift
//  SSDPTestTests
//
//  Created by Michael Kuhardt on 26.09.20.
//

import XCTest
import ResourceHelper
@testable import TinyUpnp

class UPNPMediaServerParserTests: XCTestCase {
    
    var mediaServerParser: UPNPMediaServerParser?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWithValidXML() throws {
        
        mediaServerParser = UPNPMediaServerParser()
        
        let expectation = self.expectation(description: "Parsing")
        
        
        let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/mediaServer_response_linkstation.xml").path
        XCTAssertNotNil(path, "File path must no be nul")
        
        do {
            let xmlData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            
            mediaServerParser?.parse(data: xmlData, then: {result in
                
                switch result {
                case .success(let device):
                    
                    XCTAssertEqual(device.deviceType, "urn:schemas-upnp-org:device:MediaServer:1")
                    
                    
                    expectation.fulfill()
                    
                case .failure(let error):
                    
                    
                    XCTFail("parsing error")
                }
                
            })
            /*
            mediaServerParser?.parse(data: xmlData) { [weak self] (result) in
                
                
            }
        */
            
            
        } catch {
            // contents could not be loaded
            XCTFail("error \(error.localizedDescription)")
            
            
        }
        
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    
}
