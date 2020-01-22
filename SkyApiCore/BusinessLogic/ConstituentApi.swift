//
//  ConstituentApi.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 11/19/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation

public class ConstituentApi : SkyApiBase {
    
    public func getConstituent(accessToken: String, id: String, completion: @escaping (Constituent?, Error?) -> Void) {
        let url = "https://api.sky.blackbaud.com/constituent/v1/constituents/\(id)"
        get(accessToken: accessToken, url: url, completion: { data, error in
            if let responseData = data {
                let decoder = JSONDecoder()
                if let constituent = try? decoder.decode(Constituent.self, from: responseData) {
                    print("Found constituent \(constituent.id) \(constituent.first) \(constituent.last)")
                    completion(constituent, error)
                    return
                }
            }
            completion(nil, error)
        })
    }

    /** Get a profile picture link that expires in 60 minutes, or null if the constituent has no profile picture. */
    public func getProfilePicture(accessToken: String, id: String, completion: @escaping (String?, String?, Error?) -> Void) {
        let url = "https://api.sky.blackbaud.com/constituent/v1/constituents/\(id)/profilepicture"
        get(accessToken: accessToken, url: url, completion: { data, error in
            if let responseData = data {
                let decoder = JSONDecoder()
                if let profilePictureResponse = try? decoder.decode(ProfilePictureResponse.self, from: responseData) {
                    completion(profilePictureResponse.thumbnail_url, profilePictureResponse.url, error)
                    return
                }
            }
            completion(nil, nil, error)
        })
    }

    public func findConstituent(accessToken: String, searchText: String, completion: @escaping (ConstituentSearchResult?, Error?) -> Void) {
        searchConstituents(accessToken: accessToken, searchText: searchText, limit: 1, isLookupId: false, completion: { (constituents, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let constituents = constituents,
                constituents.count > 0 else {
                completion(nil, nil)
                return
            }
            completion(constituents[0], nil)
        })
    }

    public func findConstituent(accessToken: String, lookupId: String, completion: @escaping (ConstituentSearchResult?, Error?) -> Void) {
        searchConstituents(accessToken: accessToken, searchText: lookupId, limit: 1, isLookupId: true, completion: { (constituents, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let constituents = constituents,
                constituents.count > 0 else {
                    completion(nil, nil)
                    return
            }
            completion(constituents[0], nil)
        })
    }

    public func searchConstituents(accessToken: String, searchText: String, limit: Int, isLookupId: Bool, completion: @escaping ([ConstituentSearchResult]?, Error?) -> Void) {

        let searchTextParam = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var url = "https://api.sky.blackbaud.com/constituent/v1/constituents/search?search_text=\(searchTextParam)&limit=\(limit)"
        if isLookupId {
            url = "\(url)&search_field=lookup_id"
        }
        print("searchConstituents \(url)")
        get(accessToken: accessToken, url: url, completion: { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            if let responseData = data {
                let decoder = JSONDecoder()
                if let searchResults = try? decoder.decode(ConstituentSearchResponse.self, from: responseData) {
                    completion(searchResults.value, nil)
                    return
                }
            }
            completion(nil, nil)
        })
    }

    public func createNote(accessToken: String, constituentId: String, summary: String, text: String, type: String, completion: @escaping (Error?) -> Void) {

        let url = "https://api.sky.blackbaud.com/constituent/v1/notes"

        let requestBody = CreateNoteRequest()
        requestBody.constituent_id = constituentId
        requestBody.date = FuzzyDate(from: Date())

        let jsonEncoder = JSONEncoder()
        let body: Data!
        do {
            body = try jsonEncoder.encode(requestBody)
        } catch {
            completion(error)
            return
        }

        post(accessToken: accessToken, url: url, body: body, completion: { data, error in
            if let error = error {
                completion(error)
                return
            }
//            let decoder = JSONDecoder()
//            guard let responseData = data,
//                let _ = try? decoder.decode(IdResponse.self, from: responseData) else {
//                    completion(TODO error)
//                    return
//            }

            completion(nil)
        })
    }

    public func createAction(accessToken: String, constituentId: String, category: String, summary: String, description: String, date: Date, completion: @escaping (Error?) -> Void) {

        let url = "https://api.sky.blackbaud.com/constituent/v1/actions"

        let requestBody = CreateActionRequest()
        requestBody.category = category
        requestBody.constituent_id = constituentId
        requestBody.summary = summary
        requestBody.actionDescription = description
        requestBody.date = date

        let jsonEncoder = JSONEncoder()
        let body: Data!
        do {
            body = try jsonEncoder.encode(requestBody)
        } catch {
            completion(error)
            return
        }

        post(accessToken: accessToken, url: url, body: body, completion: { data, error in
            if let error = error {
                completion(error)
                return
            }
            let decoder = JSONDecoder()
            guard let responseData = data,
                let _ = try? decoder.decode(IdResponse.self, from: responseData) else {
                    completion(nil) // TODO error
                    return
            }

            completion(nil)
        })
    }

}
