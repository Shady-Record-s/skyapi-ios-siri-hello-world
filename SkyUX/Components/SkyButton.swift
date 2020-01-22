//
//  SkyButton.swift
//  SkyUX
//
//  Created by Christi Schneider on 11/20/19.
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import Foundation
import UIKit

public class SkyButton : UIButton {

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    public init(text: String) {
        super.init(frame: CGRect.zero)
        setTitle(text, for: .normal)
        layer.cornerRadius = 3
        
        titleEdgeInsets = UIEdgeInsets(top: SkyStyles.Spacing.Containers.Large, left: SkyStyles.Spacing.Containers.Large, bottom: SkyStyles.Spacing.Containers.Large, right: SkyStyles.Spacing.Containers.Large)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public static func createPrimaryButton(text: String) -> SkyButton {
        let result = SkyButton(text: text)
        result.tintColor = SkyStyles.Colors.Text.onDark
        result.backgroundColor = SkyStyles.Colors.Backgrounds.primaryDark
        result.titleLabel!.font = SkyStyles.Fonts.buttonText
        result.setSize()
        return result
    }

    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        setSize()
    }

    private func setSize() {
        translatesAutoresizingMaskIntoConstraints = false

        widthConstraint?.isActive = false
        heightConstraint?.isActive = false

        widthConstraint = widthAnchor.constraint(equalToConstant: titleLabel!.intrinsicContentSize.width + SkyStyles.Spacing.Containers.Large * 2.0)
        widthConstraint!.isActive = true

        heightConstraint = heightAnchor.constraint(equalToConstant: titleLabel!.intrinsicContentSize.height + SkyStyles.Spacing.Containers.Large * 2.0)
        heightConstraint!.isActive = true
    }
    
}
