//
//  UPNPCDSBrowseResponseParserTests.swift
//  SSDPTestTests
//
//  Created by Michael Kuhardt on 08.11.20.
//

import XCTest
import ResourceHelper
@testable import TinyUpnp

class UPNPCDSBrowseResponseParserTests: XCTestCase {
    
    var parser: UPNPBrowseResponseParser?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingForRootContainer_Linkstation() throws {
        
        parser = UPNPBrowseResponseParser()
        
        let expectation = self.expectation(description: "Parsing")
        
        let path: String = ResourceHelper.projectRootURL(projectRef: #file,
                                                         fileName: "temp.bundle/cdsBrowseResponse_RootDirectoy_linkstation.xml").path
        XCTAssertNotNil(path, "File path must no be nul")
       
        
        do {
            let xmlData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            
            parser?.parse(data: xmlData, then: {completion in
                
                switch completion {
                case .success(let browseResponse):
                    
                    var validatedItems = [CDSContainerObject]()
                    
                    XCTAssertEqual(browseResponse.numberReturned, 3)
                    XCTAssertEqual(browseResponse.totalMatches, 3)
                    XCTAssertEqual(browseResponse.updatedId, 12)
                    
                    XCTAssertEqual(browseResponse.result.count, 3)
                    
                    for entry in browseResponse.result {
                        
                        guard let container = entry as? CDSContainerObject else {
                            XCTFail("entry should be a container")
                            return
                        }
                        
                        XCTAssertNotNil(container.searchable, "searchable should be available for passed item")
                        XCTAssertTrue(container.searchable!)
                        XCTAssertTrue(container.restricted)
                        XCTAssertEqual(container.parentID, "0")
                        XCTAssertEqual(container.classDefinition, "object.container")
                        
                        
                        switch container.id {
                        case "0$1":
                            
                            XCTAssertEqual(container.childCount, 11, "container with id \(container.id) should have 11 children")
                            XCTAssertEqual(container.title, "Musik", "container with id \(container.id) should have title Musik")
                            XCTAssertEqual(container.modificationTime, 946681369, "modificationTime of id \(container.id) does not match")
                            validatedItems.append(container)
                        case "0$2":
                            
                            XCTAssertEqual(container.childCount, 8, "container with id \(container.id) should have 11 children")
                            XCTAssertEqual(container.title, "Bilder", "container with id \(container.id) should have title Bilder")
                            XCTAssertEqual(container.modificationTime, 946681378, "modificationTime of id \(container.id) does not match")
                            validatedItems.append(container)
                        case "0$3":
                            
                            XCTAssertEqual(container.childCount, 7, "container with id \(container.id) should have 11 children")
                            XCTAssertEqual(container.title, "Videos", "container with id \(container.id) should have title Videos")
                            XCTAssertEqual(container.modificationTime, 946681373, "modificationTime of id \(container.id) does not match")
                            validatedItems.append(container)
                        default:
                            break
                        }
                    }
                    
                    XCTAssertEqual(validatedItems.count, 3, "3 entries should have been validated")
                    
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
