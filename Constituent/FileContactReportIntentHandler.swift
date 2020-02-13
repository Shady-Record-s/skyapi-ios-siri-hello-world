//
//  FileContactReportIntentHandler.swift
//  Constituent
//
//  Created by Christi Schneider on 12/27/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import Intents
import os
import SkyApiCore
import SiriDemoAnalytics

class FileContactReportIntentHandler : NSObject, FileContactReportIntentHandling {

    func handle(intent: FileContactReportIntent, completion: @escaping (FileContactReportIntentResponse) -> Swift.Void) {

        if let lookupId = intent.lookupId, !lookupId.isEmpty {
            print("File contact report for lookup ID \(lookupId)")
            doFileContactReport(lookupId: lookupId, text: intent.text!, completion: completion)
        } else {

            guard let name = intent.name else {
                print("Error: No name or lookup ID supplied")
                completion(FileContactReportIntentResponse(code: .failure, userActivity: nil))
                return
            }

            SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
                guard let accessToken = accessToken else {
                    completion(FileContactReportIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
                    return
                }

                let api = ConstituentApi()
                api.findConstituent(accessToken: accessToken, searchText: name, completion: { searchResult, error in
                    guard let searchResult = searchResult else {
                        completion(FileContactReportIntentResponse(code: .failure, userActivity: nil))
                        return
                    }

                    let lookupId = searchResult.lookup_id
                    self.doFileContactReport(lookupId: lookupId, text: intent.text!, completion: completion)
                })
            })

        }

    }

    func doFileContactReport(lookupId: String, text: String, completion: @escaping (FileContactReportIntentResponse) -> Swift.Void) {

        // TODO store a map of lookup ID to system record ID so we don't have to do lookup every time

        print("doFileContactReport \(lookupId)")

        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
            guard let accessToken = accessToken else {
                print("Error: no access token")
                completion(FileContactReportIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
                return
            }

            let api = ConstituentApi()
            api.findConstituent(accessToken: accessToken, lookupId: lookupId, completion: { (constituent, error) in

                if let error = error {
                    print("Error finding constituent: \(error)")
                    completion(FileContactReportIntentResponse(code: .failure, userActivity: nil))
                    return
                }

                guard let constituent = constituent else {
                    print("Error: no constituent search result when looking up ID \(lookupId)")
                    completion(FileContactReportIntentResponse(code: .failure, userActivity: nil))
                    return
                }

                api.createAction(accessToken: accessToken, constituentId: constituent.id, category: "Meeting", summary: "Contact Report Dictated from iPhone", description: text, date: Date(), completion: { (error) in

                    if let error = error {
                        print("Error creating action \(error)")
                        completion(FileContactReportIntentResponse(code: .failure, userActivity: nil))
                        return
                    }

                    Analytics.Track(event: "File Contact Report")

                    completion(FileContactReportIntentResponse(code: .success, userActivity: nil))

                })

            })

       })
    }

    func resolveText(for intent: FileContactReportIntent, with completion: @escaping (INStringResolutionResult) -> Void) {

        guard let text = intent.text else {
            completion(INStringResolutionResult.needsValue())
            return
        }

        completion(INStringResolutionResult.success(with: text))

    }

    func resolveLookupId(for intent: FileContactReportIntent, with completion: @escaping (INStringResolutionResult) -> Swift.Void) {

        if let lookupId = intent.lookupId, !lookupId.isEmpty {
            completion(INStringResolutionResult.success(with: lookupId))
            return
        }

        guard let name = intent.name, !name.isEmpty else {
            completion(INStringResolutionResult.notRequired())
            return
        }

        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
            guard let accessToken = accessToken else {
                completion(INStringResolutionResult.notRequired())
                return
            }

            let api = ConstituentApi()
            api.findConstituent(accessToken: accessToken, searchText: name, completion: { searchResult, error in
                guard let searchResult = searchResult else {
                    completion(INStringResolutionResult.notRequired())
                    return
                }

                completion(INStringResolutionResult.success(with: searchResult.lookup_id))
                return
            })
        })

    }

    func resolveName(for intent: FileContactReportIntent, with completion: @escaping (INStringResolutionResult) -> Swift.Void) {

        if let _ = intent.lookupId {
            if let name = intent.name {
                completion(INStringResolutionResult.success(with: name))
            } else {
                completion(INStringResolutionResult.notRequired())
            }
            return
        }

        guard let name = intent.name else {
            completion(INStringResolutionResult.needsValue())
            return
        }

        SkyApiAuthentication.retrieveAccessToken(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (accessToken) in
            guard let accessToken = accessToken else {
                completion(INStringResolutionResult.needsValue())
                return
            }

            Analytics.TrackSearch(searchName: "Constituent", pageName: "File Contact Report Intent")

            let api = ConstituentApi()
            api.findConstituent(accessToken: accessToken, searchText: name, completion: { searchResult, error in
                guard let searchResult = searchResult else {
                    completion(INStringResolutionResult.needsValue())
                    return
                }

                completion(INStringResolutionResult.success(with: searchResult.name))
                return
            })
        })

    }

}
