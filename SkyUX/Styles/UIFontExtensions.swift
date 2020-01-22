//
//  UIFontExtensions.swift
//  SkyUX
//
//  Created by Christi Schneider on 11/21/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    
    private class MyDummyClass {}

    static func loadFontWith(name: String, fileExtension: String) {
        let frameworkBundle = Bundle(for: MyDummyClass.self)
        let pathForResourceString = frameworkBundle.path(forResource: name, ofType: fileExtension)
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
        print("Loaded font \(name)")
    }

    static let loadSkyUXFonts: () = {
        loadFontWith(name: "blackbaud-sans-bold", fileExtension: "otf")
        loadFontWith(name: "blackbaud-sans-condensed-light", fileExtension: "otf")
        loadFontWith(name: "blackbaud-sans-condensed-semi-bold", fileExtension: "otf")
        loadFontWith(name: "blackbaud-sans-italic", fileExtension: "otf")
        loadFontWith(name: "blackbaud-sans", fileExtension: "otf")
    }()

}
