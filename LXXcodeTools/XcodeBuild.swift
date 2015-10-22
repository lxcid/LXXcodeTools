//
//  XcodeBuild.swift
//  LXXcodeTools
//
//  Created by Stan Chang Khin Boon on 22/10/15.
//  Copyright © 2015 lxcid. All rights reserved.
//

import Foundation

class XcodeBuild {
    struct BuildSettings {
        static let sectionHeaderPattern = "\\ABuild settings for action (.+) and target \"?([^\":]+)\"?:\\z"
        static let settingPattern = "\\A\\s*(.+)\\s=\\s(.+)\\z"
        
        enum Key : String {
            case InfoPlistFile = "INFOPLIST_FILE"
        }
        
        let settings: [String: [String: String]]
        
        init(settings: [String: [String: String]]) {
            self.settings = settings
        }
        
        init?(output: String) {
            guard
                let sectionHeaderRegex = try? NSRegularExpression(pattern: self.dynamicType.sectionHeaderPattern, options: []),
                let settingRegex = try? NSRegularExpression(pattern: self.dynamicType.settingPattern, options: [])
                else {
                    return nil
            }
            
            var settings = [String: [String: String]]()
            var currentTarget: String? = nil
            
            for line in output.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) {
                if let match = sectionHeaderRegex.firstMatchInString(line, options: [], range: NSRange(location: 0, length: line.characters.count)) {
                    currentTarget = (line as NSString).substringWithRange(match.rangeAtIndex(2))
                    settings[currentTarget!] = [String: String]()
                } else if let match = settingRegex.firstMatchInString(line, options: [], range: NSRange(location: 0, length: line.characters.count)) {
                    let key = (line as NSString).substringWithRange(match.rangeAtIndex(1))
                    let value = (line as NSString).substringWithRange(match.rangeAtIndex(2))
                    settings[currentTarget!]?[key] = value
                }
            }
            
            self.init(settings: settings)
        }
        
        init?(workspace optWorkspace: String?, scheme optScheme: String?) {
            let task = NSTask()
            task.launchPath = "/usr/bin/xcrun"
            var arguments = [ "xcodebuild", "-showBuildSettings" ]
            if let workspace = optWorkspace {
                arguments += ["-workspace", workspace]
            }
            if let scheme = optScheme {
                arguments += ["-scheme", scheme]
            }
            task.arguments = arguments
            
            let pipe = NSPipe()
            task.standardOutput = pipe
            task.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = NSString(data: data, encoding: NSUTF8StringEncoding)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) else {
                return nil
            }
            
            self.init(output: output)
        }
        
        func valueForKey(key: Key, target: String) -> String? {
            return self.settings[target]?[key.rawValue]
        }
    }
}