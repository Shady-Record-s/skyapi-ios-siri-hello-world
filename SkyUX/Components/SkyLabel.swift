//
//  SkyLabel.swift
//  SkyUX
//
//  Created by Christi Schneider on 11/20/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import UIKit

public class SkyLabel : UILabel {
    
    public init(text: String) {
        super.init(frame: CGRect.zero)
        self.text = text
        textAlignment = .center
        font = SkyStyles.Fonts.regularBodyCopy
        textColor = SkyStyles.Colors.Text.defaultColor
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public static func createPageHeading(text: String) -> SkyLabel {
        let result = SkyLabel(text: text)
        result.font = SkyStyles.Fonts.pageHeading
        return result
    }

    public static func createHeadline(text: String) -> SkyLabel {
        let result = SkyLabel(text: text)
        result.font = SkyStyles.Fonts.headline
        return result
    }

    public static func createEmphasizedBodyCopy(text: String) -> SkyLabel {
        let result = SkyLabel(text: text)
        result.font = SkyStyles.Fonts.emphasizedBodyCopy
        return result
    }
    
}
