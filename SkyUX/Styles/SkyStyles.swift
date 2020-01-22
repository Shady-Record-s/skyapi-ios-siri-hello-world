//
//  Styles.swift
//  Siri-Demo
//
//  Created by Christi Schneider on 11/12/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import UIKit

private enum FontNames: CustomStringConvertible {
    case BlackbaudSansBold
    case BlackbaudSansCondensedLight
    case BlackbaudSansCondensedSemiBold
    case BlackbaudSansItalic
    case BlackbaudSans

    var description: String {
        switch self {
        case .BlackbaudSansBold: return "BlackbaudSans-Bold"
        case .BlackbaudSansCondensedLight: return "BlackbaudSansCondensedLight"
        case .BlackbaudSansCondensedSemiBold: return "BlackbaudSansCondensedSemibold"
        case .BlackbaudSansItalic: return "BlackbaudSans-Italic"
        case .BlackbaudSans: return "BlackbaudSans"
        }
    }
}

public struct SkyStyles {
    /** See: https://developer.blackbaud.com/skyux/design/styles/spacing */
    public struct Spacing {
        /** See: https://developer.blackbaud.com/skyux/design/styles/spacing#containers */
        public struct Containers {
            /**
             Large containers often run near the edge of the viewport, so significant padding is necessary to prevent the content from feeling crunched. Examples include:
             - Pages
             - Modals
             - Tiles
             - Sectioned forms
             */
            public static let Large = CGFloat(15)
        }
        /** See https://developer.blackbaud.com/skyux/design/styles/spacing#content */
        public struct Content {
            /** Vertically arranged content */
            public struct Vertical {
                /**
                 Closely related elements have a small amount of margin between them to stay visually linked. Examples include:
                 - Form fields and their labels
                 - Section headers and the first elements in sections
                 */
                public static let Compact = CGFloat(5)
                /** Sections of loosely related content require extra vertical spacing to prevent them from running together visually. */
                public static let Separate = CGFloat(20)
            }
            /** Horizontally arranged content */
            public struct Horizontal {
                /**
                 Closely related elements have a small amount of margin between them to stay visually linked. Examples include:
                 - Status indicator icons and labels
                 - Required form field indicators
                 - Button icons and labels
                 */
                public static let Compact = CGFloat(5)
                /**
                 Multiple related elements need enough horizontal spacing to be distinguished from each other but still visually linked. Examples include:
                 - Toolbar buttons
                 - Related form fields, such as "First name" and "Last name"
                 */
                public static let Default = CGFloat(10)
            }
        }
    }
    
    /** See https://developer.blackbaud.com/skyux/design/styles/color */
    public struct Colors {
        /** See https://developer.blackbaud.com/skyux/design/styles/color#text */
        public struct Text {
            /** The default color for text */
            public static let defaultColor = UIColor(rgb: 0x212327)
            /** Text on a dark background */
            public static let onDark = UIColor(rgb: 0xffffff)
        }
        
        /** See https://developer.blackbaud.com/skyux/design/styles/color#backgrounds */
        public struct Backgrounds {
            /** Background for elements that invoke primary actions, such as a primary button */
            public static let primaryDark = UIColor(rgb: 0x0974a1)
        }

        /** See https://developer.blackbaud.com/skyux/design/styles/color#borders */
        public struct Borders {
            /** Borders that separate containers from their surroundings or that separate sections of active elements from the contents of a container such as separating a toolbar from a list of records */
            public static let neutralMedium = UIColor(rgb: 0xcdcfd2)
        }
    }
    
    /** See https://developer.blackbaud.com/skyux/design/styles/typography */
    public struct Fonts {
        /** This formats text that identifies a page, such as a page title or record name. Use this class on one element per page. */
        public static var pageHeading: UIFont? {
            return UIFont(name: FontNames.BlackbaudSansCondensedLight.description, size: 34)
        }
        /** This formats text that calls out key information on a page, such as a constituent’s total giving or the number of records in a list. Use it sparingly or you will dilute its ability to draw attention. */
        public static var headline: UIFont? {
            return UIFont(name: FontNames.BlackbaudSansBold.description, size: 16)
        }
        /** This formats text to call out key information that is slightly less important than headline text, such as constituent names in a list of contact cards. Use it sparingly or you will dilute its ability to draw attention. */
        public static var emphasizedBodyCopy: UIFont? {
            return UIFont(name: FontNames.BlackbaudSansBold.description, size: 16)
        }
        /** This is the base body font and does not require a separate class. It formats text that does not semantically fall under any of the defined types.
                TODO can we set this for all labels by default?
         */
        public static var regularBodyCopy: UIFont? {
            return UIFont(name: FontNames.BlackbaudSans.description, size: 15)
        }
        public static var buttonText: UIFont? {
            return UIFont(name: FontNames.BlackbaudSans.description, size: 18)
        }
    }
}
