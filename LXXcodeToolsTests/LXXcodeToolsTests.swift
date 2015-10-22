//
//  LXXcodeToolsTests.swift
//  LXXcodeToolsTests
//
//  Created by Stan Chang Khin Boon on 22/10/15.
//  Copyright © 2015 lxcid. All rights reserved.
//

import XCTest
@testable import LXXcodeTools

class LXXcodeToolsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        if
            let buildSettings = XcodeBuild.BuildSettings(workspace: "/Users/khinboon/Projects/d--buzz/MangaKid/MangaKid.xcworkspace", scheme: "MangaKid"),
            let infoPlistFile = buildSettings.valueForKey(.InfoPlistFile, target: "MangaKid")
        {
            print(infoPlistFile)
        }
        
        if let assetCatalog = AssetCatalogTool.printContents("/Users/khinboon/Projects/d--buzz/MangaKid/MangaKid/MangaKid/Assets.xcassets") as? [String: AnyObject] {
            if let child = assetCatalog[AssetCatalogTool.Key.Root.rawValue] as? [AnyObject] {
                print(child.first?[AssetCatalogTool.Key.Filename.rawValue])
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
