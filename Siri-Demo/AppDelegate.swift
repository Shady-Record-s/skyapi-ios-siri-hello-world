//
//  AppDelegate.swift
//  Siri-Demo
//
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import UIKit
import SkyUX
import SkyApiCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("loading SKY UX fonts")
        UIFont.loadSkyUXFonts
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Called when the application is clicked from Siri
        // Return true to indicate that your app handled the activity or false to let iOS know that your app did not handle the activity.

        guard let interaction = userActivity.interaction,
            let response = interaction.intentResponse as? PersonInfoIntentResponse,
            let responseActivity = response.userActivity,
            let intent = interaction.intent as? PersonInfoIntent else {
                return false
        }

        print(interaction)
        print(response)
        print(responseActivity)
        print(intent)

        if response.code != .success {
            // TODO handle other codes
            return true
        }

        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {

        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")

        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = components.host,
            let params = components.queryItems else {
                print("Invalid URL or query params missing")
                return false
        }

        switch (host) {
        case "auth":
            break
        default:
            print("Unexpected host " + host)
            return false
        }

        if let code = params.first(where: { $0.name == "code" })?.value {
            SkyApiAuthentication.getAccessToken(code: code)
            return true
        }

        guard let accessToken = params.first(where: { $0.name == "access_token" })?.value,
            let accessTokenExpires = params.first(where: { $0.name == "expires" })?.value,
            let refreshToken = params.first(where: { $0.name == "refresh_token" })?.value,
            let refreshTokenExpires = params.first(where: { $0.name == "refresh_expires" })?.value else {
            return false
        }

        SkyApiAuthentication.saveAuthToken(groupName: "group.com.blackbaud.bbshortcuts1", accessToken: accessToken, accessTokenExpires: accessTokenExpires, refreshToken: refreshToken, refreshTokenExpires: refreshTokenExpires)

        return true
    }
}

