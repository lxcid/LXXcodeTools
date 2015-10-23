//
//  AssetCatalogTool.swift
//  LXXcodeTools
//
//  Created by Stan Chang Khin Boon on 22/10/15.
//  Copyright © 2015 lxcid. All rights reserved.
//

import Foundation

// https://developer.apple.com/library/prerelease/mac/documentation/Darwin/Reference/ManPages/man1/actool.1.html
public class AssetCatalogTool {
    public enum Key: String {
        case Root = "com.apple.actool.catalog-contents"
        
        case Filename = "filename"
    }
    
    public static func printContents(document: String) -> AnyObject? {
        let task = NSTask()
        task.launchPath = "/usr/bin/xcrun"
        let arguments = [ "actool", "--print-contents", document ]
        task.arguments = arguments
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let format: UnsafeMutablePointer<NSPropertyListFormat> = nil
        return try? NSPropertyListSerialization.propertyListWithData(data, options: [ .Immutable ], format: format)
    }
}
