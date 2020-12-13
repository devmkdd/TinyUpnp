//
//  CDSResource.swift
//  SSDPTest
//
//  Created by Michael Kuhardt on 15.11.20.
//

import Foundation


/**
 
 This indentifies a resource of a content directory service. A resource is typically some type of a
 binary asset, such as photo, song, video, etc. A 'res' element contains a uri
 that identifies the resource.
 
 */
public struct CDSResource {
    
    public var uri: String?
    
    // uri locator for resource update
    public var importUri: String?
    
    // dentifies the streaming or transport protocol for transmitting the resource
    public var protocolInfo: String
    
    //  The size, in bytes, of the resource
    public var size: UInt?
    
    /* The 'duration' attribute identifies the duration of the playback of the resource, at normal speed.
     The form of the duration string is:
    H*:MM:SS.F*, or H*:MM:SS.F0/F1
    where :
    H* means any number of digits (including no digits) to indicate elapsed hours
    MM means exactly 2 digits to indicate minutes (00 to 59)
    SS means exactly 2 digits to indicate seconds (00 to 59)
    F* means any number of digits (including no digits) to indicate fractions of seconds
    F0/F1 means a fraction, with F0 and F1 at least one digit long, and F0 < F1
    The string may be preceded by an optional + or – sign, and the decimal point itself
    may be omitted if there are no fractional second digits. */
    public var duration: String?
    
    // The bitrate in bytes/second of the resource.
    public var bitrate: UInt?
    
    // The sample frequency of the resource in Hz
    public var sampleFrequency: UInt?
    
    // The bits per sample of the resource
    public var bitsPerSample: UInt?
    
    //  Number of audio channels of the resource, e.g. 1 for mono, 2 for stereo, 6 for Dolby surround, etc.
    public var nrAudioChannels: UInt?
    
    // X*Y resolution of the resource (image or video). The string pattern is restricted to strings of the form:
    //  (one or more digits,'x', followed by one or more digits).
    public var resolution: String?
    
    //  The color depth in bits of the resource (image or video).
    public var colorDepth: UInt?
    
    //  Some statement of the protection type of the resource (not standardized).
    public var protection: String?
    
}


// MARK: - CustomStringConvertible
extension CDSResource: CustomStringConvertible {
    
    
    public var description: String {
        
        return "CDSResource\n" +
            " uri: \(String(describing: uri))\n" +
            " importUri: \(String(describing: importUri))\n" +
            " protocolInfo: \(protocolInfo)\n" +
            " size: \(String(describing: size))\n" +
            " duration: \(String(describing: duration))\n" +
            " bitrate: \(String(describing: bitrate))\n" +
            " sampleFrequency: \(String(describing: sampleFrequency))\n" +
            " bitsPerSample: \(String(describing: bitsPerSample))\n" +
            " nrAudioChannels: \(String(describing: nrAudioChannels))\n" +
            " resolution: \(String(describing: resolution))\n" +
            " colorDepth: \(String(describing: colorDepth))\n" +
            " protection: \(String(describing: protection))\n"
    }
    
}
