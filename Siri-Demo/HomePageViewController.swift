//
//  HomePageViewController.swift
//  Siri-Demo
//
//  Created by Christi Schneider on 2/13/20.
//  Copyright © 2020 Blackbaud. All rights reserved.
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

class HomePageViewController: UIViewController {

    var titleLabelConstraints: [NSLayoutConstraint] = []
    var titleLabel: SkyLabel!
    var authButton: SkyButton!
    var dictateContactReportButton: SkyButton!
    var authenticatedView: UIStackView!
    var contactReportDictationEngine: ContactReportDictationEngine?

    // TODO display SKY wait while busy
    var viewDidLoadBusy = false
    var viewSafeAreaInsetsDidChangeBusy = false
    var checkIfAuthenticatedBusy = false
    var logoutBusy = false

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewDidLoadBusy = true

        print("viewDidLoad")

        titleLabel = SkyLabel.createPageHeading(text: "Welcome to Blackbaud")
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        SkyApiAuthentication.isAuthenticated(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (isAuthenticated) in

            print("Authenticated: \(isAuthenticated)")

            DispatchQueue.main.async() {
                [weak self] in
                guard let self = self else { return }

                var authButtonText: String
                var authTarget: Selector
                if (isAuthenticated) {
                    authButtonText = "Logout"
                    authTarget = #selector(self.logout)
                } else {
                    authButtonText = "Login"
                    authTarget = #selector(self.login)
                }

                self.authButton = SkyButton.createPrimaryButton(text: authButtonText)
                self.authButton.addTarget(self, action: authTarget, for: .touchUpInside)
                self.view.addSubview(self.authButton)
                self.authButton.translatesAutoresizingMaskIntoConstraints = false
                self.view.addConstraints([
                    // button horizontal position - center
                    self.authButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    // button vertical position - below label
                    self.authButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.Separate),
                ])

                self.authenticatedView = UIStackView()
                self.authenticatedView.axis = .vertical
                self.authenticatedView.alignment = .center
                self.authenticatedView.spacing = SkyStyles.Spacing.Content.Vertical.Separate
                self.authenticatedView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(self.authenticatedView)
                self.view.addConstraints([
                    self.authenticatedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.authenticatedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: SkyStyles.Spacing.Containers.Large),
                    self.authenticatedView.topAnchor.constraint(equalTo: self.authButton.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.Separate),
                    self.authenticatedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -SkyStyles.Spacing.Containers.Large),
                    self.authenticatedView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -SkyStyles.Spacing.Containers.Large)
                ])
                self.authenticatedView.isHidden = !isAuthenticated

                let divider = UIView()
                divider.backgroundColor = SkyStyles.Colors.Borders.neutralMedium
                self.authenticatedView.addArrangedSubview(divider)
                self.authenticatedView.addConstraints([
                    divider.heightAnchor.constraint(equalToConstant: 2),
                    divider.widthAnchor.constraint(equalTo: self.authenticatedView.widthAnchor)
                ])

                self.addShortcutUI()

                self.addContactReportUI()

                print("Adding listener for becoming active to check if authenticated")
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(self.checkIfAuthenticated),
                    name: UIApplication.didBecomeActiveNotification,
                    object: nil)

                let nc = NotificationCenter.default
                nc.addObserver(self, selector: #selector(self.checkIfAuthenticated), name: Notification.Name("UserLoggedIn"), object: nil)

                self.viewDidLoadBusy = false
            }
        })

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        contactReportDictationEngine?.stop()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        viewSafeAreaInsetsDidChangeBusy = true

        titleLabelConstraints.forEach { constraint in
            constraint.isActive = false
        }
        self.view.removeConstraints(titleLabelConstraints)
        titleLabelConstraints.removeAll()

        // label horizontal position - center
        titleLabelConstraints.append(titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        // label vertical position - top
        titleLabelConstraints.append(titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top + SkyStyles.Spacing.Containers.Large))
        // label width - full width of container minus padding
        titleLabelConstraints.append(titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -2 * SkyStyles.Spacing.Containers.Large))
        self.view.addConstraints(titleLabelConstraints)

        viewSafeAreaInsetsDidChangeBusy = false
    }

    func addContactReportUI() {

        let dictateContactReportView = UIStackView()
        dictateContactReportView.axis = .vertical
        dictateContactReportView.alignment = .center
        dictateContactReportView.spacing = SkyStyles.Spacing.Content.Vertical.Compact
        dictateContactReportView.translatesAutoresizingMaskIntoConstraints = false
        self.authenticatedView.addArrangedSubview(dictateContactReportView)
        self.authenticatedView.addConstraints([
            dictateContactReportView.leadingAnchor.constraint(equalTo: self.authenticatedView.leadingAnchor),
            dictateContactReportView.trailingAnchor.constraint(equalTo: self.authenticatedView.trailingAnchor)
        ])

        let dictateReportLabel = SkyLabel.createEmphasizedBodyCopy(text: "Dictate a contact report")
        dictateReportLabel.lineBreakMode = .byWordWrapping
        dictateReportLabel.numberOfLines = 0
        dictateContactReportView.addArrangedSubview(dictateReportLabel)
        dictateContactReportView.addConstraints([
            dictateReportLabel.widthAnchor.constraint(lessThanOrEqualTo: dictateContactReportView.widthAnchor)
        ])
        let dictateContactReportInfoLabel = SkyLabel(text: "After contacting a constituent, add a note with details to the constituent record.")
        dictateContactReportInfoLabel.lineBreakMode = .byWordWrapping
        dictateContactReportInfoLabel.numberOfLines = 0
        dictateContactReportView.addArrangedSubview(dictateContactReportInfoLabel)
        dictateContactReportView.addConstraints([
            dictateContactReportInfoLabel.widthAnchor.constraint(lessThanOrEqualTo: dictateContactReportView.widthAnchor)
        ])
        self.dictateContactReportButton = SkyButton.createPrimaryButton(text: "Start")
        self.dictateContactReportButton.addTarget(self, action: #selector(dictateContactReportClicked), for: .touchUpInside)
        dictateContactReportView.addArrangedSubview(self.dictateContactReportButton)

        let dictateContactReportStatusLabel = SkyLabel(text: "")
        let dictateContactReportResultLabel = SkyLabel.createEmphasizedBodyCopy(text: "")
        contactReportDictationEngine = ContactReportDictationEngine(statusLabel: dictateContactReportStatusLabel, resultLabel: dictateContactReportResultLabel)
        dictateContactReportView.addArrangedSubview(dictateContactReportStatusLabel)
        dictateContactReportView.addArrangedSubview(dictateContactReportResultLabel)

    }

    func addShortcutUI() {

        let title = "Ask Siri to show you a constituent"
        let helpText = "Specify a constituent's name or \"Ask Each Time\" by clicking \"Look up constituent\" on the popup."
        let action = #selector(self.addConstituentInfoShortcut)

        let addShortcutView = UIStackView()
        addShortcutView.axis = .vertical
        addShortcutView.alignment = .center
        addShortcutView.spacing = SkyStyles.Spacing.Content.Vertical.Compact
        addShortcutView.translatesAutoresizingMaskIntoConstraints = false
        self.authenticatedView.addArrangedSubview(addShortcutView)
        self.authenticatedView.addConstraints([
            addShortcutView.leadingAnchor.constraint(equalTo: self.authenticatedView.leadingAnchor),
            addShortcutView.trailingAnchor.constraint(equalTo: self.authenticatedView.trailingAnchor)
        ])

        let addShortcutLabel = SkyLabel.createEmphasizedBodyCopy(text: title)
        addShortcutLabel.lineBreakMode = .byWordWrapping
        addShortcutLabel.numberOfLines = 0
        addShortcutView.addArrangedSubview(addShortcutLabel)
        addShortcutView.addConstraints([
            addShortcutLabel.widthAnchor.constraint(lessThanOrEqualTo: addShortcutView.widthAnchor)
        ])
        let addShortcutInfoLabel = SkyLabel(text: helpText)
        addShortcutInfoLabel.lineBreakMode = .byWordWrapping
        addShortcutInfoLabel.numberOfLines = 0
        addShortcutView.addArrangedSubview(addShortcutInfoLabel)
        addShortcutView.addConstraints([
            addShortcutInfoLabel.widthAnchor.constraint(lessThanOrEqualTo: addShortcutView.widthAnchor)
        ])
        let addShortcutButton = INUIAddVoiceShortcutButton(style: .automaticOutline)
        addShortcutButton.addTarget(self, action: action, for: .touchUpInside)
        addShortcutView.addArrangedSubview(addShortcutButton)

    }

    @objc
    func dictateContactReportClicked() {
        DispatchQueue.main.async() {
            [weak self] in
            guard let self = self else { return }
            
            if self.dictateContactReportButton.titleLabel?.text == "Start" {
                Analytics.TrackButtonClick(buttonName: "Dictate Contact Report Start", pageName: "Home")

                self.dictateContactReportButton.setTitle("Stop", for: .normal)
                self.contactReportDictationEngine?.startDictation(completion: {
                    self.dictateContactReportButton.setTitle("Start", for: .normal)
                })
            } else {
                Analytics.TrackButtonClick(buttonName: "Dictate Contact Report Stop", pageName: "Home")

                self.dictateContactReportButton.setTitle("Start", for: .normal)
                self.contactReportDictationEngine?.stop()
            }
        }
    }

    @objc
    func addConstituentInfoShortcut() {

        Analytics.TrackButtonClick(buttonName: "Add Constituent Lookup Siri Shortcut", pageName: "Home")
        
        let intent = ConstituentInfoIntent()
        intent.suggestedInvocationPhrase = "Find a constituent"
        guard let shortcut = INShortcut(intent: intent) else {
            return
        }

        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self

        present(vc, animated: true, completion: nil)
    }

    @objc
    func checkIfAuthenticated() {
        print("checkIfAuthenticated")
        checkIfAuthenticatedBusy = true
        SkyApiAuthentication.isAuthenticated(groupName: "group.com.blackbaud.bbshortcuts1", completionHandler: { (isAuthenticated) in

            print("Authenticated: \(isAuthenticated)")

            DispatchQueue.main.async() {
                [weak self] in
                guard let self = self else { return }

                if isAuthenticated {
                    self.authButton.setTitle("Logout", for: .normal)
                    self.authButton.removeTarget(self, action: #selector(self.login), for: .touchUpInside)
                    self.authButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
                }
                self.authenticatedView.isHidden = !isAuthenticated
                self.checkIfAuthenticatedBusy = false

            }
        })
    }

    @objc
    func login(sender: UIButton!) {

        Analytics.TrackButtonClick(buttonName: "Login", pageName: "Home")

        if AppProperties.UseFakeLoginAndData {

            print("WARNING: Fake logging in")
            let theFuture = Calendar.current.date(byAdding: .year, value: 100, to: Date())!.iso8601
            SkyApiAuthentication.saveAuthToken(groupName: "group.com.blackbaud.bbshortcuts1", accessToken: "fake", accessTokenExpires: theFuture, refreshToken: "fake", refreshTokenExpires: theFuture)
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        
        } else {

             guard let url = SkyApiAuthentication.LoginPage else {
                 return
             }

             // Open in safari
             UIApplication.shared.open(url)
             // Having issues getting in-app redirect to work, TODO revisit
             // Might work better with Universal Link
     //        let request = URLRequest(url: url)
     //        let config = WKWebViewConfiguration()
     //        config.setURLSchemeHandler(<#T##urlSchemeHandler: WKURLSchemeHandler?##WKURLSchemeHandler?#>, forURLScheme: "bbsiridemo")
     //        let webview = WKWebView(frame: self.view.frame, configuration: config)
     //        self.view.addSubview(webview)
     //        self.view.addConstraints([
     //            // webview horizontal position - center
     //            webview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
     //            // webview vertical position - center
     //            webview.topAnchor.constraint(equalTo: self.view.centerYAnchor),
     //            // webview width - full width of container
     //            webview.widthAnchor.constraint(equalTo: self.view.widthAnchor),
     //            // webview height - full height of container
     //            webview.heightAnchor.constraint(equalTo: self.view.heightAnchor),
     //        ])
     //        webview.load(request)

        }

    }

    @objc
    func logout(sender: UIButton!) {
        logoutBusy = true
        
        Analytics.TrackButtonClick(buttonName: "Logout", pageName: "Home")

        SkyApiAuthentication.logout(groupName: "group.com.blackbaud.bbshortcuts1")

        DispatchQueue.main.async() {
            [weak self] in
            guard let self = self else { return }

            self.authButton.setTitle("Login", for: .normal)
            self.authButton.removeTarget(self, action: #selector(self.logout), for: .touchUpInside)
            self.authButton.addTarget(self, action: #selector(self.login), for: .touchUpInside)
            self.authenticatedView.isHidden = true
            self.logoutBusy = false
        }
    }

}


extension HomePageViewController: INUIAddVoiceShortcutViewControllerDelegate {

    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        dismiss(animated: true, completion: nil)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}
