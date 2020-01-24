//
//  Authentication.swift
//  SkyApiCore
//
//  Created by Christi Schneider on 11/21/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import SiriDemoAppProperties
import SiriDemoAnalytics

public class SkyApiAuthentication {

    public static var LoginPage: URL? {
        let redirectUri = "https%3A%2F%2Fhost.nxt.blackbaud.com%2Fapp-redirect%2Fredirect-siridemo%2F"
        return URL(string: "https://oauth2.sky.blackbaud.com/authorization?client_id=\(AppProperties.SkyAppId)&response_type=code&redirect_uri=\(redirectUri)")
    }

    public static func saveAuthToken(groupName: String, accessToken: String, accessTokenExpires: String, refreshToken: String, refreshTokenExpires: String) {

        let myDefaults = UserDefaults.init(suiteName: groupName)!
        myDefaults.set(accessToken, forKey: "accessToken")
        myDefaults.set(accessTokenExpires, forKey: "accessTokenExpires")
        myDefaults.set(refreshToken, forKey: "refreshToken")
        myDefaults.set(refreshTokenExpires, forKey: "refreshTokenExpires")

        // TODO save in secure storage on the phone
        // Not implemented for this demo since it requires additional checking and UI to handle exceptions

        print("Successfully authenticated with SKY API")
    }

    public static func logout(groupName: String) {
        let myDefaults = UserDefaults.init(suiteName: groupName)!
        myDefaults.removeObject(forKey: "accessToken")
        myDefaults.removeObject(forKey: "accessTokenExpires")
        myDefaults.removeObject(forKey: "refreshToken")
        myDefaults.removeObject(forKey: "refreshTokenExpires")
    }

    public static func retrieveAccessToken(groupName: String, completionHandler: @escaping (String?) -> Void) {

        let myDefaults = UserDefaults.init(suiteName: groupName)!

        guard let accessToken = myDefaults.string(forKey: "accessToken"),
            let accessTokenExpiresStr = myDefaults.string(forKey: "accessTokenExpires"),
            let refreshToken = myDefaults.string(forKey: "refreshToken"),
            let refreshTokenExpiresStr = myDefaults.string(forKey: "refreshTokenExpires"),
            let accessTokenExpires = accessTokenExpiresStr.iso8601,
            let refreshTokenExpires = refreshTokenExpiresStr.iso8601 else {

                print("User not authenticated")
                completionHandler(nil)
                return
        }

        if (refreshTokenExpires < Date()) {
            print("User's refresh token has expired")
            myDefaults.removeObject(forKey: "accessToken")
            myDefaults.removeObject(forKey: "accessTokenExpires")
            myDefaults.removeObject(forKey: "refreshToken")
            myDefaults.removeObject(forKey: "refreshTokenExpires")
            completionHandler(nil)
            return
        }

        if (accessTokenExpires < Date()) {
            print("User's access token has expired. Refreshing.")
            refreshAuthToken(refreshToken: refreshToken, groupName: groupName, completionHandler: completionHandler)
            return
        }

        completionHandler(accessToken)

    }

    public static func getAccessToken(code: String) {
        doAccessTokenRequest(body: "grant_type=authorization_code&code=\(code)", completion: { (accessToken) in

        })
    }
    private static func refreshAuthToken(refreshToken: String, groupName: String, completionHandler: @escaping (String?) -> Void) {
        doAccessTokenRequest(body: "grant_type=refresh_token&refresh_token=\(refreshToken)", completion: { (accessToken) in
            completionHandler(accessToken)
        })
    }

    private static func doAccessTokenRequest(body: String, completion: @escaping (String?) -> Void) {

        let requestBody = "\(body)&redirect_uri=https%3A%2F%2Fhost.nxt.blackbaud.com%2Fapp-redirect%2Fredirect-siridemo%2F"

        let body = requestBody.data(using: .utf8)

        let url = URL(string: "https://oauth2.sky.blackbaud.com/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        let authHeader = Data(("\(AppProperties.SkyAppId):\(AppProperties.SkyAppSecret)").utf8).base64EncodedString()
        request.setValue("Basic \(authHeader)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            let now = Date()

            if let error = error {
                print("Error getting auth token \(String(describing: error))")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error getting auth token \(String(describing: data))")
                return
            }
            guard let data = data else {
                print("Error getting auth token \(httpResponse.statusCode)")
                return
            }
            guard httpResponse.statusCode == 200 else {
                let dataString = String(data: data, encoding: .utf8) ?? data.debugDescription
                print("Error getting auth token \(httpResponse.statusCode) \(dataString)")
                return
            }

            let decoder = JSONDecoder()
            guard let token = try? decoder.decode(OAuthToken.self, from: data) else {
                print("Error decoding auth token response \(data)")
                return
            }

            let accessTokenExpires = now.addingTimeInterval(TimeInterval(token.expires_in - 15)).iso8601
            let refreshTokenExpires = now.addingTimeInterval(TimeInterval(token.refresh_token_expires_in - 15)).iso8601

            Analytics.SetUser(userId: token.user_id, environmentId: token.environment_id, environmentName: token.environment_name,
                              legalEntityId: token.legal_entity_id, legalEntityName: token.legal_entity_name)

            saveAuthToken(groupName: "group.com.blackbaud.bbshortcuts1", accessToken: token.access_token, accessTokenExpires: accessTokenExpires, refreshToken: token.refresh_token, refreshTokenExpires: refreshTokenExpires)
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedIn"), object: nil)

            completion(token.access_token)
        })
        task.resume()
    }

    public static func isAuthenticated(groupName: String, completionHandler: @escaping (Bool) -> Void) {
        retrieveAccessToken(groupName: groupName, completionHandler: { (accessToken) in
            guard let _ = accessToken else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        })
    }

}
