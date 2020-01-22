// This commented out code is included because it may be useful to someone.
// It is definitely incomplete and should only be used as a starting point or reference.
// T-ODOs have a character added so they don't show up as tasks in various IDEs or when searching.

// The reason I did not use this code in the final demo is because the system
// "Get Visual Code" intent does not behave the way I would want to be able to
// get a code for a specific page. It only lets you get one code per app.
// Additionally, I was not able to get the QR code to appear. I think this is
// due to an Apple bug but it may be that I just wrote bad code. I was unable
// to find a sample of working code to compare against.

////
////  GetVisualCodeIntentHandler.swift
////  Person
////
////  Created by Christi Schneider on 12/23/19.
////  Copyright © 2019 Blackbaud. All rights reserved.
////
//
//import Foundation
//import Intents
////import Contacts
//import SkyApiCore
//import CoreImage
//import UIKit
//
//class GetVisualCodeIntentHandler : NSObject, INGetVisualCodeIntentHandling {
//
//    func resolveVisualCodeType(for intent: INGetVisualCodeIntent, with completion: (INVisualCodeTypeResolutionResult) -> Void) {
//
//        print("GetVisualCodeIntentHandler.resolveVisualCodeType")
//
//        completion(INVisualCodeTypeResolutionResult.success(with: INVisualCodeType.contact))
//
//    }
//
//    func confirm(intent: INGetVisualCodeIntent, completion: @escaping (INGetVisualCodeIntentResponse) -> Void) {
//
//        print("GetVisualCodeIntentHandler.confirm")
//
//        completion(INGetVisualCodeIntentResponse(code: INGetVisualCodeIntentResponseCode.success, userActivity: nil))
//    }
//
//    func handle(intent: INGetVisualCodeIntent, completion: @escaping (INGetVisualCodeIntentResponse) -> Void) {
//
//        print("GetVisualCodeIntentHandler.handle")
//
//        let response = INGetVisualCodeIntentResponse(code: INGetVisualCodeIntentResponseCode.success, userActivity: nil)
//
//
//        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
//            guard let accessToken = accessToken else {
//                // T-ODO
//                return
//            }
//
//            let api = ConstituentApi()
//            // T-ODO use a different kind of intent so we can specify constit
//            api.findConstituent(accessToken: accessToken, searchText: "Robert Hernandez", completion: { searchResult, error in
//
//                if let _ = error {
//                    // T-ODO
//                    return
//                }
//
//                guard let searchResult = searchResult else {
//                    // T-ODO
//                    return
//                }
//
//                api.getConstituent(accessToken: accessToken, id: searchResult.id, completion: { constit, error2 in
//
//                    if let _ = error2 {
//                        // T-ODO
//                        return
//                    }
//
//                    guard let constit = constit else {
//                        // T-ODO
//                        return
//                    }
//
//                    let vcard = self.getVCard(constit: constit, searchResult: searchResult)
//                    let data = vcard.data(using: String.Encoding.ascii)
//
//                    guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
//                        // T-ODO
//                        return
//                    }
//
//                    filter.setValue(data, forKey: "inputMessage")
//                    let transform = CGAffineTransform(scaleX: 10, y: 10)
//                    guard let output = filter.outputImage?.transformed(by: transform) else {
//                        // T-ODO
//                        return
//                    }
//
//
//
//                    // Get a CIContext
//                    let context = CIContext()
//                    // Create a CGImage *from the extent of the outputCIImage*
//                    guard let cgImage = context.createCGImage(output, from: output.extent) else {
//                        // T-ODO
//                        return
//                    }
//                    // Finally, get a usable UIImage from the CGImage
//                    let processedImage = UIImage(cgImage: cgImage)
//                    guard let jpgData = processedImage.jpegData(compressionQuality: 1.0) else {
//                        // T-ODO
//                        return
//                    }
//
//
////                    let uimage = UIImage(ciImage: output)
////                    guard let pngData = uimage.pngData() else {
////                        // T-ODO
////                        return
////                    }
//
////                    response.visualCodeImage = INImage(imageData: jpgData)
//                    response.visualCodeImage = INImage(url: URL(string: "https://blackbaud.com")!)
//
//                    completion(response)
//                })
//
//            })
//        })
//
////        CNContactVCardSerialization.data(with: <#T##[CNContact]#>)
//
//    }
//
//    func getVCard(constit: Constituent, searchResult: ConstituentSearchResult) -> String {
//
//        let address = searchResult.address
//            .replacingOccurrences(of: "\\", with: "\\\\")
//            .replacingOccurrences(of: "\"", with: "\\\"")
//
//        return "BEGIN:VCARD\n" +
//            "VERSION:4.0\n" +
//            "N:\(constit.last);\(constit.first);;;\n" +
//            "FN:\(searchResult.name)\n" +
////            "ORG:Bubba Gump\n" +
////            "TITLE:Shrimp Man\n" +
////            "PHOTO;MEDIATYPE=image/gif:http://www.example.com/dir_photos/my_photo.gif\n" +
////            "TEL;TYPE=work,voice;VALUE=uri:tel:+1-111-555-1212\n" +
//            "ADR;TYPE=PRIMARY;PREF=1;LABEL=\"\(address)\":;;;;;;\n" +
//            "EMAIL:\(searchResult.email)\n" +
//            "REV:20191223T195243Z\n" + // T-ODO use current date
//            "END:VCARD"
//
//    }
//
//}
