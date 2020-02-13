//
//  Properties.swift
//  SiriDemoAppProperties
//
//  Created by Christi Schneider on 1/17/20.
//  Copyright © 2020 Blackbaud. All rights reserved.
//

import Foundation

public struct AppProperties {

    // TODO you probably want to use real data :) 
    public static let UseFakeLoginAndData = true

    public static let SkyAppId = "TODO insert your app id here"

    // TODO The SkyAppSecret and SkyApiSubscriptionKey are secrets that should not be included in a production app.
    // SKY OAuth and SKY API requests should be made from a secure server rather than a front-end application.
    // See the README for more information.
    public static let SkyAppSecret = "TODO insert your app secret here"
    public static let SkyApiSubscriptionKey = "TODO insert your subscription key here"

    public static let EnableAnalytics = true
    public static let EnableAnalyticsWithMixpanel = true
    // TODO set these to your own Mixpanel tokens if you'd like to use Mixpanel tracking.
    #if DEBUG
    public static let MixpanelToken = "3fe355c87fd0a60a09234246d4fffda7"
    #else
    public static let MixpanelToken = "1e2f49c5717a884a6009cc2352e20158"
    #endif

}
