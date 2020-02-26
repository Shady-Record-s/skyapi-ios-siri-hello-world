//
//  ViewController.swift
//  Siri-Demo
//
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import UIKit
import Intents
import IntentsUI
import WebKit
import SkyUX
import SkyApiCore
import CoreSpotlight
import CoreServices
import SiriDemoAnalytics
import SiriDemoAppProperties

class MyViewController: UIViewController {
    
    // Constraints are added after view lays out or the text will run into the notch
    var mainStack = UIView()
    var mainStackConstraints: [NSLayoutConstraint] = []
    
//    var titleLabelConstraints: [NSLayoutConstraint] = []
//    var titleLabel: SkyLabel!
//    var goButtonConstraints: [NSLayoutConstraint] = []
//    var goButton: SkyButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad")
        
        self.view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
//        mainStack.axis = .vertical
//        mainStack.alignment = .center
//        mainStack.distribution = .equalSpacing
//        mainStack.spacing = SkyStyles.Spacing.Content.Vertical.Separate
        
        let titleLabel = SkyLabel.createPageHeading(text: "Welcome to Blackbaud")
        mainStack.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addConstraints([
            titleLabel.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: mainStack.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
        ])

        //        let scrollView = UIScrollView()
        //        self.view.addSubview(scrollView)
        //        scrollView.backgroundColor = UIColor.yellow
        //        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //        self.view.addConstraints([
        //            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.Separate),
        //            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -SkyStyles.Spacing.Containers.Large),
        //            scrollView.bottomAnchor.constraint(equalTo: goButton.topAnchor, constant: -SkyStyles.Spacing.Content.Vertical.Separate),
        //            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: SkyStyles.Spacing.Containers.Large)
        //        ])
        //
        //        let stackView = UIStackView()
        //        scrollView.addSubview(stackView)
        //        stackView.translatesAutoresizingMaskIntoConstraints = false
        //        scrollView.addConstraints([
        //            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        //            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
        //            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        //            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
        //        ])
        //
        //        addText(stackView: stackView, text: "This application is a native Swift application for iOS that demonstrates how to access " +
        //            "constituent data via SKY API, experiments with Siri capabilities, displays a native SKY UX adaptation, and " +
        //            "negotiates security using OAuth 2.0 Authorization Code Flow.")
        
        let goButton = SkyButton.createPrimaryButton(text: "Check it out!")
        mainStack.addSubview(goButton)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addConstraints([
            goButton.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
            goButton.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor),
//            goButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
//            goButton.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
        ])
        
    }
    
    private func addText(stackView: UIStackView, text: String) {
        
        let label = SkyLabel(text: text)
        stackView.addArrangedSubview(label)
        label.textAlignment = .center
        stackView.addConstraints([
            label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])

    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        mainStackConstraints.forEach { $0.isActive = false }
        self.view.removeConstraints(mainStackConstraints)
        mainStackConstraints.removeAll()
        
        mainStackConstraints.append(mainStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top + SkyStyles.Spacing.Containers.Large))
        mainStackConstraints.append(mainStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -SkyStyles.Spacing.Containers.Large))
        mainStackConstraints.append(mainStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + SkyStyles.Spacing.Containers.Large)))
        mainStackConstraints.append(mainStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: SkyStyles.Spacing.Containers.Large))
        self.view.addConstraints(mainStackConstraints)

//        titleLabelConstraints.forEach { $0.isActive = false }
//        self.view.removeConstraints(titleLabelConstraints)
//        titleLabelConstraints.removeAll()
//
//        // label horizontal position - center
//        titleLabelConstraints.append(titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
//        // label vertical position - top
//        titleLabelConstraints.append(titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top + SkyStyles.Spacing.Containers.Large))
//        // label width - full width of container minus padding
//        titleLabelConstraints.append(titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * SkyStyles.Spacing.Containers.Large))
//        self.view.addConstraints(titleLabelConstraints)
//
//        goButtonConstraints.forEach { $0.isActive = false }
//        self.view.removeConstraints(goButtonConstraints)
//        goButtonConstraints.removeAll()
//
//        goButtonConstraints.append(goButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
////        goButtonConstraints.append(goButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor))
//        //        goButtonConstraints.append(goButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.view.safeAreaInsets.bottom + SkyStyles.Spacing.Containers.Large)))
//        self.view.addConstraints(goButtonConstraints)
        
    }

}
