//
//  SkyApiBase.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 11/19/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import SiriDemoAppProperties

public class SkyApiBase {

    public init() {
    }

    public func get(accessToken: String, url urlString: String, completion: @escaping (Data?, Error?) -> Void) {

        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(AppProperties.SkyApiSubscriptionKey, forHTTPHeaderField: "Bb-Api-Subscription-Key")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        doRequest(request: request, completion: completion)

    }

    public func post(accessToken: String, url urlString: String, body: Data?, completion: @escaping (Data?, Error?) -> Void) {

        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body

        request.setValue(AppProperties.SkyApiSubscriptionKey, forHTTPHeaderField: "Bb-Api-Subscription-Key")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        doRequest(request: request, completion: completion)

    }

    private func doRequest(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let responseData = data {
                        completion(responseData, error)
                        return
                    }
                } else {
                    completion(nil, HttpError(statusCode: httpResponse.statusCode, data: data, error: error))
                    return
                }
            }
            if error == nil {
                completion(nil, SkyApiError(data: data))
                return
            }
            completion(nil, error)
        })
        task.resume()
    }

}
