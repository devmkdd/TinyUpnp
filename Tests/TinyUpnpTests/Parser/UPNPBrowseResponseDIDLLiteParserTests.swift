//
//  UPNPBrowseResponseDIDLLiteParserTests.swift
//  SSDPTestTests
//
//  Created by Michael Kuhardt on 15.11.20.
//

import XCTest
import ResourceHelper
@testable import TinyUpnp

class UPNPBrowseResponseDIDLLiteParserTests: XCTestCase {
    
    
    var parser: UPNPBrowseResponseDIDLLiteParser?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingForAlbumWithSuccess_HurraSoNicht() throws {
        
        parser = UPNPBrowseResponseDIDLLiteParser()
        
        var parsedIds = [String]()
        
        let expectation = self.expectation(description: "Parsing")
        
        let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/cdsBrowseResponse_album_gzk.xml").path
        XCTAssertNotNil(path, "File path must no be nul")
       
        
        do {
            let xmlData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            parser?.parse(data: xmlData, then: {result in
                
                switch result {
                case .success(let items):
                    
                    XCTAssertEqual(11, items.objects.count, "parser should return 11 items")
                    
                    
                    for entry in items.objects {
                        
                        guard let item = entry as? CDSItemObject else {
                            XCTFail("returned item is no item object")
                            break
                        }
                        XCTAssertNotNil(item, "results are expected to return items in case of music tracks")
                        
                        XCTAssertTrue(item.album == "Hurra! Hurra! So Nicht", "album for item \(item.id) not matching")
                        XCTAssertTrue(item.artist == "Gisbert zu Knyphausen", "artist \(item.artist ?? "") for item \(item.id) not matching")
                        XCTAssertTrue(item.albumArtist == "Gisbert zu Knyphausen", "albumArtist for item \(item.id) not matching")
                        XCTAssertTrue(item.genre == "Singer-Songwriter", "genre for item \(item.id) not matching")
                        XCTAssertTrue(item.parentID == "0$1$15$189$25883$28907", "parentID for item \(item.id) not matching")
                        XCTAssertTrue(item.classDefinition == "object.item.audioItem.musicTrack", "classDefinition for item \(item.id) not matching")
                        
                        XCTAssertEqual(item.resources?.count, 1, "item should have exactly one resource")
                        
                        let resource = item.resources?.first
                    
                        
                        switch item.id {
                        case "0$1$15$189$25883$28907R7387402":
                            
                            XCTAssertTrue(item.title == "Dreh dich nicht um", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 10, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Gisbert Zu Knyphausen", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7387402.m4a", "resource uri for item \(item.id) not matching")
                            XCTAssertEqual(item.modificationTime, 1422817802, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        case "0$1$15$189$25883$28907R7385610":
                            
                            XCTAssertTrue(item.title == "Es Ist Still Auf Dem Rastplatz Krachgarten", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 4, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Gisbert Zu Knyphausen", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7385610.m4a", "resource uri for item \(item.id) not matching")
                            XCTAssertEqual(item.modificationTime, 1422817620, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        case "0$1$15$189$25883$28907R7385354":
                            
                            XCTAssertTrue(item.title == "Grau, Grau, Grau", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 3, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Jens Fricke/Frenzy Suhr/Gunnar Ennen/Sebastian Deufel", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7385354.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817605, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                            
                        case "0$1$15$189$25883$28907R7384842":
                            
                            XCTAssertTrue(item.title == "Hey", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 1, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Gisbert Zu Knyphausen", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7384842.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817323, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        case "0$1$15$189$25883$28907R7386890":
                            
                            XCTAssertTrue(item.title == "Hurra, Hurra ! So Nicht", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 9, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Jens Fricke/Sebastian Deufel/Gunnar Ennen/Frenzy Suhr", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7386890.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817719, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        case "0$1$15$189$25883$28907R7385866":
                            
                            XCTAssertTrue(item.title == "Ich bin Freund von Klischees und funkelnden Sternen", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 5, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Jens Fricke/Gunnar Ennen/Frenzy Suhr/Sebastian Deufel", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7385866.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817638, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                            
                        case "0$1$15$189$25883$28907R7386122":
                            
                            XCTAssertTrue(item.title == "Kräne", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 6, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Jens Fricke/Gunnar Ennen/Frenzy Suhr/Sebastian Deufel", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7386122.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817664, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                            
                        case "0$1$15$189$25883$28907R7386634":
                            
                            XCTAssertTrue(item.title == "Melancholie", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 8, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Gisbert Zu Knyphausen", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7386634.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817704, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                            
                        case "0$1$15$189$25883$28907R7386378":
                            
                            XCTAssertTrue(item.title == "Morsches Holz", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 7, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Jens Fricke/Sebastian Deufel/Frenzy Suhr/Gunnar Ennen", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7386378.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817675, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                            
                        case "0$1$15$189$25883$28907R7387146":
                            
                            XCTAssertTrue(item.title == "Nichts als Gespenster", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 11, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Gunnar Ennen/Jens Fricke/Sebastian Deufel/Frenzy Suhr", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7387146.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817785, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                            
                        case "0$1$15$189$25883$28907R7385098":
                            
                            XCTAssertTrue(item.title == "Seltsames Licht", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 2, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Sebastian Deufel/Frenzy Suhr/Gunnar Ennen/Jens Fricke", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I7385098.m4a")
                            XCTAssertEqual(item.modificationTime, 1422817592, "modificationTime for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        
                        default:
                            break
                        }
                    }
                    
                    
                    XCTAssertEqual(parsedIds.count, 11, "11 items should have been validated")
                    
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
    
    
    
    func testParsingForAlbumWithSuccess_LiveInBerlin() throws {
        
        parser = UPNPBrowseResponseDIDLLiteParser()
        
        var parsedIds = [String]()
        
        let expectation = self.expectation(description: "Expect result data math the one from the xml")
        
        let path: String = ResourceHelper.projectRootURL(projectRef: #file, fileName: "temp.bundle/cdsBrowseResponse_album_liveInBerlin.xml").path
        XCTAssertNotNil(path, "File path must no be nul")
       
        
        do {
            let xmlData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            parser?.parse(data: xmlData, then: {result in
                
                switch result {
                case .success(let items):
                    
                    XCTAssertEqual(21, items.objects.count, "parser should return 21 items")
                    
                    for entry in items.objects {
                        
                        guard let item = entry as? CDSItemObject else {
                            XCTFail("returned item is no item object")
                            break
                        }
                        XCTAssertNotNil(item, "results are expected to return items in case of music tracks")
                        
                        XCTAssertTrue(item.album == "Live in Berlin Soundtrack", "album for item \(item.id) not matching")
                        XCTAssertTrue(item.artist == "Depeche Mode", "artist \(item.artist ?? "") for item \(item.id) not matching")
                        XCTAssertTrue(item.creator == "Depeche Mode", "creator \(item.creator ?? "") for item \(item.id) not matching")
                        XCTAssertTrue(item.albumArtist == "Depeche Mode", "albumArtist for item \(item.id) not matching")
                        XCTAssertTrue(item.genre == "Future-Pop | Synthy-Pop", "genre for item \(item.id) not matching")
                        XCTAssertTrue(item.parentID == "0$1$15$161$6591$30042", "parentID for item \(item.id) not matching")
                        XCTAssertTrue(item.classDefinition == "object.item.audioItem.musicTrack", "classDefinition for item \(item.id) not matching")
                        
                        XCTAssertEqual(item.resources?.count, 1, "item should have exactly one resource")
                        
                        let resource = item.resources?.first
                        
                        XCTAssertNotNil(item.albumArtURIs, "albumArtURIs for item \(item.id) should not be nil")
                        let albumart = item.albumArtURIs?.first
                    
                        
                        switch item.id {
                        case "0$1$15$161$6591$30042R25211658":
                            
                            XCTAssertTrue(item.title == "A Pain That I'm Used To", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 1, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25211658.m4a", "resource uri for item \(item.id) not matching")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25211658.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            
                           
                            
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R34205706":
                            
                            XCTAssertTrue(item.title == "A Question Of Time", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 2, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I34205706.m4a", "resource uri for item \(item.id) not matching")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I34205706.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25144074":
                            
                            XCTAssertTrue(item.title == "Angel", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 2, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25144074.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25144074.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                            
                        case "0$1$15$161$6591$30042R25144842":
                            
                            XCTAssertTrue(item.title == "Black Celebration", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 5, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25144842.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25144842.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25210890":
                            
                            XCTAssertTrue(item.title == "But Not Tonight", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 9, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25210890.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25210890.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25212170":
                            
                            XCTAssertTrue(item.title == "Enjoy The Silence", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 3, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25212170.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25212170.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                            
                        case "0$1$15$161$6591$30042R43851786":
                            
                            XCTAssertTrue(item.title == "Goodbye", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 10, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I43851786.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I43851786.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                            
                        case "0$1$15$161$6591$30042R25212938":
                            
                            XCTAssertTrue(item.title == "Halo", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 6, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25212938.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25212938.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                            
                        case "0$1$15$161$6591$30042R25211146":
                            
                            XCTAssertTrue(item.title == "Heaven", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 10, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25211146.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25211146.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                            
                        case "0$1$15$161$6591$30042R25213450":
                            
                            XCTAssertTrue(item.title == "I Feel You", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 8, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25213450.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25213450.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                            
                        case "0$1$15$161$6591$30042R25213194":
                            
                            XCTAssertTrue(item.title == "Just Can't Get Enough", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 7, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Vincent John Martin", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25213194.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25213194.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25213706":
                            
                            XCTAssertTrue(item.title == "Never Let Me Down Again", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 9, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25213706.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25213706.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25212426":
                            
                            XCTAssertTrue(item.title == "Personal Jesus", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 4, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25212426.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25212426.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25145354":
                            
                            XCTAssertTrue(item.title == "Policy Of Truth", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 7, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25145354.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25145354.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25144586":
                            
                            XCTAssertTrue(item.title == "Precious", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 4, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25144586.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25144586.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25212682":
                            
                            XCTAssertTrue(item.title == "Shake The Disease", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 5, "tracknumber for item \(item.id) not matching")
                            XCTAssertTrue(item.composer == "Martin Lee Gore", "composer for item \(item.id) not matching")
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25212682.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25212682.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25145098":
                            
                            XCTAssertTrue(item.title == "Should Be Higher", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 6, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25145098.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25145098.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25211402":
                            
                            XCTAssertTrue(item.title == "Soothe My Soul", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 11, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25211402.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25211402.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25476106":
                            
                            XCTAssertTrue(item.title == "The Child Inside", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 8, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25476106.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25476106.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25144330":
                            
                            XCTAssertTrue(item.title == "Walking In My Shoes", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 3, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25144330.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25144330.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        case "0$1$15$161$6591$30042R25143818":
                            
                            XCTAssertTrue(item.title == "Welcome To My World", "title for item \(item.id) not matching")
                            XCTAssertEqual(item.originalTrackNumber, 1, "tracknumber for item \(item.id) not matching")
                            XCTAssertNil(item.composer)
                            XCTAssertTrue(resource?.uri == "http://10.0.0.4:9050/disk/DLNA-PNAAC_ISO_320-OP01-FLAGS01700000/O0$1$8I25143818.m4a")
                            XCTAssertEqual(albumart, "http://10.0.0.4:9050/disk/O0$1$8I25143818.jpg?scale=160x160", "albumArt for item \(item.id) not matching")
                            parsedIds.append(item.id)
                        
                        default:
                            break
                        }
                    }
                    
                    
                    XCTAssertEqual(parsedIds.count, 21, "21 items should have been validated")
                    
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
