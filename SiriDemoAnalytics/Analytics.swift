//
//  Analytics.swift
//  SiriDemoAnalytics
//
//  Created by Christi Schneider on 1/24/20.
//  Copyright © 2020 Blackbaud. All rights reserved.
//

import Foundation
import SiriDemoAppProperties
import Mixpanel

public class Analytics {
    
    static var initialized = false

    public static func initialize() {
        
        if initialized {
            return
        }

        guard AppProperties.EnableAnalytics else {
            return
        }

        var superProperties = Dictionary<String, String>()
        superProperties["BlackbaudLabsProject"] = "SKYSiriSample"
        superProperties["UsingRealData"] = (!AppProperties.UseFakeLoginAndData).description

//        if let receipt = Bundle.main.appStoreReceiptURL {
//            let isTestFlight = receipt.absoluteString.contains("sandboxReceipt")
//            superProperties["IsTestFlight"] = isTestFlight.description
//        }
        superProperties["Configuration"] = Config.appConfiguration.description

        if AppProperties.EnableAnalyticsWithMixpanel {

            print("Initializing Mixpanel instrumentation")
            Mixpanel.initialize(token: AppProperties.MixpanelToken)
            initialized = true

            Mixpanel.mainInstance().registerSuperProperties(superProperties)

        }

    }

    // Not going to unset user on log out because people don't share phones
    public static func SetUser(userId: String, environmentId: String, environmentName: String, legalEntityId: String, legalEntityName: String) {

        guard AppProperties.EnableAnalytics else {
            return
        }

        if AppProperties.EnableAnalyticsWithMixpanel {
            let mixpanel = Mixpanel.mainInstance()
            // This makes the current ID (by default an auto-generated GUID)
            // and the user's BBID guid interchangeable distinct ids (but not retroactively).
            mixpanel.createAlias(userId, distinctId: mixpanel.distinctId)
            // To create a user profile, you must call identify
            mixpanel.identify(distinctId: mixpanel.distinctId)
            mixpanel.registerSuperProperties([
                "Environment ID": environmentId,
                "Environment Name": environmentName,
                "Legal Entity ID": legalEntityId,
                "Legal Entity Name": legalEntityName
            ])
        }

    }

    public static func Track(event: String, properties: Dictionary<String, String>? = nil) {

        print(event)

        guard AppProperties.EnableAnalytics else {
            return
        }

        if AppProperties.EnableAnalyticsWithMixpanel {
            Mixpanel.mainInstance().track(event: event, properties: properties)
        }

    }

    public static func TrackButtonClick(buttonName: String, pageName: String?, properties: Dictionary<String, String>? = nil) {

        print("\(buttonName) button clicked from \(pageName ?? "unknown") page")

        guard AppProperties.EnableAnalytics else {
            return
        }

        var props = properties ?? Dictionary<String, String>()
        props["Action"] = "Clicked"
        props["Page Name"] = pageName
        props["Button Name"] = buttonName

        if AppProperties.EnableAnalyticsWithMixpanel {
            Mixpanel.mainInstance().track(event: "Button", properties: props)
        }

    }

    public static func TrackSearch(searchName: String, pageName: String?, properties: Dictionary<String, String>? = nil) {

        print("\(searchName) search executed from \(pageName ?? "unknown") page")

        guard AppProperties.EnableAnalytics else {
            return
        }

        var props = properties ?? Dictionary<String, String>()
        props["Action"] = "Search Executed"
        props["Page Name"] = pageName
        props["Search Name"] = searchName

        if AppProperties.EnableAnalyticsWithMixpanel {
            Mixpanel.mainInstance().track(event: "Search", properties: props)
        }

    }

}

enum AppConfiguration: CustomStringConvertible {
    case Debug
    case TestFlight
    case AppStore

    var description : String {
        switch self {
            case .Debug: return "Debug"
            case .TestFlight: return "TestFlight"
            case .AppStore: return "AppStore"
        }
    }
}

struct Config {
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}
