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

        print("WARNING: Fake getConstituent")
        let constit = Constituent()
        constit.email = "rob.hernandez@fake.com"
        constit.first = "Robert"
        constit.full_name = "Dr. Robert C. Hernandez"
        constit.id = "280"
        constit.initials = "RCH"
        constit.last = "Hernandez"
        completion(constit, nil)

        // let url = "https://api.sky.blackbaud.com/constituent/v1/constituents/\(id)"
        // get(accessToken: accessToken, url: url, completion: { data, error in
        //     if let responseData = data {
        //         let decoder = JSONDecoder()
        //         if let constituent = try? decoder.decode(Constituent.self, from: responseData) {
        //             print("Found constituent \(constituent.id) \(constituent.first) \(constituent.last)")
        //             completion(constituent, error)
        //             return
        //         }
        //     }
        //     completion(nil, error)
        // })
    }

    /** Get a profile picture link that expires in 60 minutes, or null if the constituent has no profile picture. */
    public func getProfilePicture(accessToken: String, id: String, completion: @escaping (String?, String?, Error?) -> Void) {

        print("WARNING: Fake getProfilePicture")
        completion("https://s21arnx01doc01blkbsa.blob.core.windows.net/blackbauddocumentsvc/tenants/8e4f1b56-c2fe-4189-a7ed-855d7881ca16/documents/d759cbe0-90bb-42f3-ad9e-5d6d769a9a90/CD3AADF5-0F54-41B9-AF5C-4984A943E177_thumbnail.jpg?sv=2015-12-11&sr=b&sig=w%2BoVDZrjbMuWxORBi4vvgChyA0Myfm441QU77PWQw5Y%3D&se=2020-01-22T22%3A44%3A32Z&sp=r",
                   "https://s21arnx01doc01blkbsa.blob.core.windows.net/blackbauddocumentsvc/tenants/8e4f1b56-c2fe-4189-a7ed-855d7881ca16/documents/f44d7eda-295d-4387-9a0b-3a4c6dece2d6/CD3AADF5-0F54-41B9-AF5C-4984A943E177.jpg?sv=2015-12-11&sr=b&sig=nXWosKb2FpDEsTWCBflh8YwIRPSv8DHnh4pFSztFk3E%3D&se=2020-01-22T22%3A47%3A00Z&sp=r",
                   nil)

        // let url = "https://api.sky.blackbaud.com/constituent/v1/constituents/\(id)/profilepicture"
        // get(accessToken: accessToken, url: url, completion: { data, error in
        //     if let responseData = data {
        //         let decoder = JSONDecoder()
        //         if let profilePictureResponse = try? decoder.decode(ProfilePictureResponse.self, from: responseData) {
        //             completion(profilePictureResponse.thumbnail_url, profilePictureResponse.url, error)
        //             return
        //         }
        //     }
        //     completion(nil, nil, error)
        // })
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

        print("WARNING: Fake searchConstituents")

        let constit1 = ConstituentSearchResult()
        constit1.address = "65 Fairchild St.\r\nCharleston, SC 29492"
        constit1.deceased = false
        constit1.email = "rob.hernandez@fake.com"
        constit1.fundraiser_status = "Active"
        constit1.id = "280"
        constit1.inactive = false
        constit1.lookup_id = "96"
        constit1.name = "Dr. Robert C. Hernandez"

        if isLookupId || limit == 1 {
            completion([constit1], nil)
            return
        }

        let constit2 = ConstituentSearchResult()
        constit2.address = "65 Fairchild St.\r\nCharleston, SC 29492"
        constit2.deceased = false
        constit2.email = "wendy.hernandez@fake.com"
        constit2.fundraiser_status = "Active"
        constit2.id = "410"
        constit2.inactive = false
        constit2.lookup_id = "260"
        constit2.name = "Wendy Hernandez"

        completion([constit1, constit2], nil)

        // let searchTextParam = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // var url = "https://api.sky.blackbaud.com/constituent/v1/constituents/search?search_text=\(searchTextParam)&limit=\(limit)"
        // if isLookupId {
        //     url = "\(url)&search_field=lookup_id"
        // }
        // print("searchConstituents \(url)")
        // get(accessToken: accessToken, url: url, completion: { data, error in
        //     if let error = error {
        //         completion(nil, error)
        //         return
        //     }
        //     if let responseData = data {
        //         let decoder = JSONDecoder()
        //         if let searchResults = try? decoder.decode(ConstituentSearchResponse.self, from: responseData) {
        //             completion(searchResults.value, nil)
        //             return
        //         }
        //     }
        //     completion(nil, nil)
        // })
    }

    public func createNote(accessToken: String, constituentId: String, summary: String, text: String, type: String, completion: @escaping (Error?) -> Void) {

        print("WARNING: Fake createNote")
        completion(nil)

//         let url = "https://api.sky.blackbaud.com/constituent/v1/notes"

//         let requestBody = CreateNoteRequest()
//         requestBody.constituent_id = constituentId
//         requestBody.date = FuzzyDate(from: Date())

//         let jsonEncoder = JSONEncoder()
//         let body: Data!
//         do {
//             body = try jsonEncoder.encode(requestBody)
//         } catch {
//             completion(error)
//             return
//         }

//         post(accessToken: accessToken, url: url, body: body, completion: { data, error in
//             if let error = error {
//                 completion(error)
//                 return
//             }
// //            let decoder = JSONDecoder()
// //            guard let responseData = data,
// //                let _ = try? decoder.decode(IdResponse.self, from: responseData) else {
// //                    completion(TODO error)
// //                    return
// //            }

//             completion(nil)
//         })
    }

    public func createAction(accessToken: String, constituentId: String, category: String, summary: String, description: String, date: Date, completion: @escaping (Error?) -> Void) {

        print("WARNING: Fake createAction")
        completion(nil)

        // let url = "https://api.sky.blackbaud.com/constituent/v1/actions"

        // let requestBody = CreateActionRequest()
        // requestBody.category = category
        // requestBody.constituent_id = constituentId
        // requestBody.summary = summary
        // requestBody.actionDescription = description
        // requestBody.date = date

        // let jsonEncoder = JSONEncoder()
        // let body: Data!
        // do {
        //     body = try jsonEncoder.encode(requestBody)
        // } catch {
        //     completion(error)
        //     return
        // }

        // post(accessToken: accessToken, url: url, body: body, completion: { data, error in
        //     if let error = error {
        //         completion(error)
        //         return
        //     }
        //     let decoder = JSONDecoder()
        //     guard let responseData = data,
        //         let _ = try? decoder.decode(IdResponse.self, from: responseData) else {
        //             completion(nil) // TODO error
        //             return
        //     }

        //     completion(nil)
        // })
    }

}
