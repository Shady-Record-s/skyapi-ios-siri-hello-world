// This commented out code is included because it may be useful to someone.
// It is definitely incomplete and should only be used as a starting point or reference.
// T-ODOs have a character added so they don't show up as tasks in various IDEs or when searching.

// The reason I did not use this code in the final demo is because the system
// "Create Note" intent does not behave the way I would want to be able to add
// a note or action to a specific constituent, and it is not much extra effort to just
// write a custom intent that does exactly what I want.

////
////  CreateNoteIntentHandler.swift
////  Person
////
////  Created by Christi Schneider on 12/17/19.
////  Copyright © 2019 Blackbaud. All rights reserved.
////
//
//import Foundation
//import Intents
//import os
//import SkyApiCore
//
//extension String {
//    func index(from: Int) -> Index {
//        return self.index(startIndex, offsetBy: from)
//    }
//
//    func substring(from: Int) -> String {
//        let fromIndex = index(from: from)
//        return String(self[fromIndex...])
//    }
//
//    func substring(to: Int) -> String {
//        let toIndex = index(from: to)
//        return String(self[..<toIndex])
//    }
//}
//
//class CreateNoteIntentHandler : NSObject, INCreateNoteIntentHandling {
//
//    static var _constituentId: String?
//    static var _constituentNameForId: String?
//
//    func resolveTitle(for intent: INCreateNoteIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
//        guard let title = intent.title else {
//            completion(INSpeakableStringResolutionResult.needsValue())
//            return
//        }
//
//        if title.spokenPhrase.count > 50 {
//            let shortenedTitle = INSpeakableString(spokenPhrase: title.spokenPhrase.substring(to: 50))
//            completion(INSpeakableStringResolutionResult.confirmationRequired(with: shortenedTitle))
//        }
//
//        completion(INSpeakableStringResolutionResult.success(with: title))
//    }
//
//    func resolveContent(for intent: INCreateNoteIntent, with completion: @escaping (INNoteContentResolutionResult) -> Void) {
//        guard let content = intent.content as? INTextNoteContent,
//            let _ = content.text else {
//            if let _ = intent.content as? INImageNoteContent {
//                // T-ODO I think we can add images as notes
//                completion(INNoteContentResolutionResult.unsupported())
//                return
//            }
//            completion(INNoteContentResolutionResult.needsValue())
//            return
//        }
//
//        completion(INNoteContentResolutionResult.success(with: content))
//    }
//
//    func resolveGroupName(for intent: INCreateNoteIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
//
//        CreateNoteIntentHandler._constituentNameForId = intent.groupName?.spokenPhrase
//        CreateNoteIntentHandler._constituentId = nil
//
//        guard let constituentName = intent.groupName else {
//            completion(INSpeakableStringResolutionResult.needsValue())
//            return
//        }
//
//        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
//            guard let accessToken = accessToken else {
//                // T-ODO
////                let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
////                completion(INSpeakableStringResolutionResult(code: .failureRequiringAppLaunch, userActivity: activity))
//                return
//            }
//
//            let api = ConstituentApi()
//            api.findConstituent(accessToken: accessToken, searchText: constituentName.spokenPhrase, completion: { constituent, error in
//                if let _ = error {
//                    // T-ODO
////                    completion(INSpeakableStringResolutionResult.)
//                    return
//                }
//                guard let constituent = constituent else {
//                    completion(INSpeakableStringResolutionResult.unsupported())
//                    return
//                }
//                CreateNoteIntentHandler._constituentId = constituent.id
//                CreateNoteIntentHandler._constituentNameForId = constituent.name
//                print("Setting constituent name \(constituent.name) for id \(constituent.id)")
//                completion(INSpeakableStringResolutionResult.success(with: INSpeakableString(spokenPhrase: constituent.name)))
//                return
//            })
//        })
//    }
//
//    func confirm(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
//        // T-ODO
//        let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
//        completion(INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.success, userActivity: activity))
//    }
//
//    func handle(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
//
//        print("Found constituent \(CreateNoteIntentHandler._constituentId ?? "") \(CreateNoteIntentHandler._constituentNameForId ?? "")")
//
//        guard let constituentName = intent.groupName?.spokenPhrase,
//            let constituentNameForId = CreateNoteIntentHandler._constituentNameForId,
//            constituentNameForId == constituentName,
//            let constituentId = CreateNoteIntentHandler._constituentId,
//            let title = intent.title?.spokenPhrase,
//            let content = intent.content as? INTextNoteContent,
//            let contentText = content.text else {
//
//                // T-ODO
////                completion(INCreateNoteIntentResponse.)
//                return
//        }
//
//        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
//            guard let accessToken = accessToken else {
//                // T-ODO
//                //                let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
//                //                completion(INSpeakableStringResolutionResult(code: .failureRequiringAppLaunch, userActivity: activity))
//                return
//            }
//
//            let api = ConstituentApi()
//            api.createNote(accessToken: accessToken, constituentId: constituentId, summary: title, text: contentText, type: "Personal", completion: { error in
//                if let _ = error {
//                    // T-ODO
//                    return
//                }
//                completion(INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.success, userActivity: nil))
//                return
//            })
//        })
//    }
//
////    func handle(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
////        os_log("Handling the get constituent intent")
////        print("Search text: \(intent.searchText!)")
////
////        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
////            guard let accessToken = accessToken else {
////                let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
////                completion(INCreateNoteIntentResponse(code: .failureRequiringAppLaunch, userActivity: activity))
////                return
////            }
////
////            self.callSkyApi(accessToken: accessToken, searchText: intent.searchText!, completion: completion)
////        })
////    }
////
////    func callSkyApi(accessToken: String, searchText: String, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
////        print("Querying SKY API")
////
////        let api = ConstituentApi()
////        api.findConstituent(accessToken: accessToken, searchText: searchText, completion: { constituent, error in
////            if let constituent = constituent {
////
////                api.getProfilePicture(accessToken: accessToken, id: constituent.id, completion: { thumbnailUrl, url, error in
////
////                    let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
////                    activity.userInfo!["address"] = constituent.address
////                    activity.userInfo!["deceased"] = constituent.deceased
////                    activity.userInfo!["email"] = constituent.email
////                    activity.userInfo!["fundraiser_status"] = constituent.fundraiser_status
////                    activity.userInfo!["id"] = constituent.id
////                    activity.userInfo!["inactive"] = constituent.inactive
////                    activity.userInfo!["lookup_id"] = constituent.lookup_id
////                    activity.userInfo!["name"] = constituent.name
////                    activity.userInfo!["profilePictureThumbnailUrl"] = thumbnailUrl
////                    let response = INCreateNoteIntentResponse.success(name: constituent.name)
////                    response.userActivity = activity
////                    completion(response)
////
////                })
////
////            } else {
////                let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
////                completion(INCreateNoteIntentResponse(code: .failure, userActivity: activity))
////            }
////        })
////    }
////
////    func resolveSearchText(for intent: INCreateNoteIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
////        if intent.searchText == "searchText" {
////            completion(INStringResolutionResult.needsValue())
////        }else{
////            completion(INStringResolutionResult.success(with: intent.searchText ?? ""))
////        }
////    }
//
//}
