//
//  PersonIntentHandler.swift
//  Person
//
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import Intents
import os
import SkyApiCore

class PersonInfoIntentHandler : NSObject, PersonInfoIntentHandling {

    func handle(intent: PersonInfoIntent, completion: @escaping (PersonInfoIntentResponse) -> Void) {
        os_log("Handling the get constituent intent")
        print("Search text: \(intent.searchText!)")

        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
            guard let accessToken = accessToken else {
                let activity = NSUserActivity(activityType: "com.blackbaud.Siri-Demo")
                completion(PersonInfoIntentResponse(code: .failureRequiringAppLaunch, userActivity: activity))
                return
            }

            self.callSkyApi(accessToken: accessToken, searchText: intent.searchText!, completion: completion)
        })
    }

    func callSkyApi(accessToken: String, searchText: String, completion: @escaping (PersonInfoIntentResponse) -> Void) {
        print("Querying SKY API")

        let api = ConstituentApi()
        api.findConstituent(accessToken: accessToken, searchText: searchText, completion: { searchResult, error in
            if let searchResult = searchResult {

                api.getConstituent(accessToken: accessToken, id: searchResult.id, completion: { constituent, error2 in

                    if let _ = error2 {
                        // TODO error handling
                        return
                    }

                    guard let constituent = constituent else {
                        // TODO error handling
                        return
                    }

                    api.getProfilePicture(accessToken: accessToken, id: searchResult.id, completion: { thumbnailUrl, url, error in

                        var nameComponents = PersonNameComponents()
                        nameComponents.givenName = constituent.first
                        nameComponents.familyName = constituent.last

                        // TODO grab the image from the URL and set it here
                        let image: INImage? = nil

                        let activity = NSUserActivity(activityType: "com.blackbaud.Siri-Demo")
                        let response = PersonInfoIntentResponse.success(name: searchResult.name, lookupId: searchResult.lookup_id)
                        response.constituent = INPerson(personHandle: INPersonHandle(value: searchResult.email, type: .emailAddress), nameComponents: nameComponents, displayName: searchResult.name, image: image, contactIdentifier: nil, customIdentifier: searchResult.id)
                        response.id = searchResult.id
                        response.address = searchResult.address
                        response.deceased = searchResult.deceased as NSNumber
                        response.email = searchResult.email
                        response.fundraiserStatus = searchResult.fundraiser_status
                        response.inactive = searchResult.inactive as NSNumber
                        response.lookupId = searchResult.lookup_id
                        if let thumbnailUrl = thumbnailUrl {
                            response.profilePictureThumbnailUrl = URL(string: thumbnailUrl)
                        }
                        response.userActivity = activity
                        completion(response)

                    })

                })


            } else {
                let activity = NSUserActivity(activityType: "com.blackbaud.Siri-Demo")
                completion(PersonInfoIntentResponse(code: .failure, userActivity: activity))
            }
        })
    }

    func resolveSearchText(for intent: PersonInfoIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if intent.searchText == "searchText" {
            completion(INStringResolutionResult.needsValue())
        }else{
            completion(INStringResolutionResult.success(with: intent.searchText ?? ""))
        }
    }

}
