// This commented out code is included because it may be useful to someone.
// It is definitely incomplete and should only be used as a starting point or reference.
// T-ODOs have a character added so they don't show up as tasks in various IDEs or when searching.

// The reason I did not use this code in the final demo is because the system
// "Send Message" intent does not behave the way I would want to be able to find
// contact information for a constituent via SKY API and then send a message to
// that contact info using the system messages app. The system intent actually
// does the opposite - pulls contact information from the phone contacts only
// and use your app to send the message.

////
////  SendMessageIntentHandler.swift
////  Person
////
////  Created by Christi Schneider on 12/16/19.
////  Copyright © 2019 Blackbaud. All rights reserved.
////
//
//import Foundation
//import Intents
//import os
//import SkyApiCore
//
//class SendMessageIntentHandler : NSObject, INSendMessageIntentHandling {
//
//    func resolveRecipients(for intent: INSendMessageIntent, with completion: ([INSendMessageRecipientResolutionResult]) -> Void) {
//        if let recipients = intent.recipients {
//
//            // If no recipients were provided we'll need to prompt for a value.
//            if recipients.count == 0 {
//                completion([INSendMessageRecipientResolutionResult.needsValue()])
//                return
//            }
//
//            SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
//                guard let accessToken = accessToken else {
//                    let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
//                    completion([INSendMessageRecipientResolutionResult(code: .failureRequiringAppLaunch, userActivity: activity)])
//                    return
//                }
//
//                let api = ConstituentApi()
//
//                var resolutionResults = [INSendMessageRecipientResolutionResult]()
//                for recipient in recipients {
//
//                    api.searchConstituents(accessToken: accessToken, searchText: recipient.displayName, limit: 3, completion: { constituents, error in
//                            if let constituents = constituents {
//
//                                switch constituents.count {
//                                case 2  ... Int.max:
//                                    // We need Siri's help to ask user to pick one from the matches.
//                                    resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
//
//                                case 1:
//                                    // We have exactly one matching contact
//                                    // T-ODO set number
//                                    resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
//
//                                case 0:
//                                    // We have no contacts matching the description provided
//                                    resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
//
//                                default:
//                                    break
//
//                                }
//                            }
//                            completion(resolutionResults)
//                    })
//                }
//            })
//        }
//    }
//
//    func resolveContent(for intent: INSendMessageIntent, with completion: (INStringResolutionResult) -> Void) {
//        if let text = intent.content, !text.isEmpty {
//            completion(INStringResolutionResult.success(with: text))
//        } else {
//            completion(INStringResolutionResult.needsValue())
//        }
//    }
//
//    func resolveSpeakableGroupName(for: INSendMessageIntent, with: (INSpeakableStringResolutionResult) -> Void) {
//
//    }
//
//    func confirm(intent: INSendMessageIntent, completion: (INSendMessageIntentResponse) -> Void) {
//        // Verify user is authenticated and your app is ready to send a message.
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
//        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
//        completion(response)
//    }
//
//    func handle(intent: INSendMessageIntent, completion: (INSendMessageIntentResponse) -> Void) {
//        // Implement your application logic to send a message here.
//
//        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
//        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
//        if let msgContent = intent.content {
//            if let msgTo = intent.recipients {
//                let tomsg = msgTo.first!.displayName
//                wormhole.passMessageObject(("\(tomsg)" as NSString), identifier: "tomsg")
//                wormhole.passMessageObject(("\(msgContent)" as NSString), identifier: "contentmsg")
//            }
//        }
//        completion(response)
//    }
//
//
////    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
////        os_log("Handling the send message intent")
////
////        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
////            guard let accessToken = accessToken else {
////                let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
////                completion(INSendMessageIntentResponse(code: .failureRequiringAppLaunch, userActivity: activity))
////                return
////            }
////
////            self.callSkyApi(accessToken: accessToken, searchText: intent.searchText!, completion: completion)
////        })
////    }
////
////    func callSkyApi(accessToken: String, searchText: String, completion: @escaping (INSendMessageIntentResponse) -> Void) {
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
////                    let response = INSendMessageIntentResponse.success(name: constituent.name)
////                    response.userActivity = activity
////                    completion(response)
////
////                })
////
////            } else {
////                let activity = NSUserActivity(activityType: "com.blackbaud.siridemo")
////                completion(INSendMessageIntentResponse(code: .failure, userActivity: activity))
////            }
////        })
////    }
////
////    func resolveSearchText(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
////        if intent.searchText == "searchText" {
////            completion(INStringResolutionResult.needsValue())
////        }else{
////            completion(INStringResolutionResult.success(with: intent.searchText ?? ""))
////        }
////    }
//
//}
