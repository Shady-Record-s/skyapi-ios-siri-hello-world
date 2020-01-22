//
//  IntentViewController.swift
//  PersonUI
//
//  Copyright © 2019 Blackbaud. All rights reserved.
//

import IntentsUI
import SkyApiCore
import SkyUX

// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - INUIHostedViewControlling

    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.

        guard let intent = interaction.intent as? PersonInfoIntent else {
           completion(true, parameters, self.desiredSize)
           return
        }

        UIFont.loadSkyUXFonts

        let viewSize = configureUI(with: intent, of: interaction)
        completion(true, [], viewSize)
        return
    }

    private func configureUI(with intent: PersonInfoIntent, of interaction: INInteraction) -> CGSize {

        guard let intentResponse = interaction.intentResponse as? PersonInfoIntentResponse else {
            print("Error getting data from interaction")

            let viewSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            configureErrorUI()
            return viewSize
        }

        guard let address = intentResponse.address,
            let deceasedNum = intentResponse.deceased,
            let deceased = Bool(exactly: deceasedNum),
            let email = intentResponse.email,
            let inactiveNum = intentResponse.inactive,
            let inactive = Bool(exactly: inactiveNum),
            let lookupId = intentResponse.lookupId,
            let name = intentResponse.name else {

                print("Error getting constituent data from user info")

                let viewSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                configureErrorUI()
                return viewSize
        }

        let thumbnailUrl = intentResponse.profilePictureThumbnailUrl

        let height = loadAndConfigureConstitInfo(name: name, address: address, deceased: deceased, email: email, inactive: inactive, lookupId: lookupId, thumbnailUrl: thumbnailUrl)
        return CGSize(width: extensionContext!.hostedViewMaximumAllowedSize.width, height: height)
    }

    private func configureErrorUI() {
        let vc = UIViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.didMove(toParent: self)

        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // TODO make this pretty and helpful
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Sorry, something went wrong"
        vc.view.addSubview(errorLabel)
        errorLabel.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
    }

    private func loadAndConfigureConstitInfo(
        name: String,
        address: String,
        deceased: Bool,
        email: String,
        inactive: Bool,
        lookupId: String,
        thumbnailUrl: URL?) -> CGFloat {

        let vc = UIViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.bounds
        vc.didMove(toParent: self)

        view.addConstraints([
            vc.view.topAnchor.constraint(equalTo: view.topAnchor, constant: SkyStyles.Spacing.Containers.Large),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SkyStyles.Spacing.Containers.Large),
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SkyStyles.Spacing.Containers.Large),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SkyStyles.Spacing.Containers.Large)
        ])

        let rightView = UIViewController()
        rightView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        vc.view.addSubview(rightView.view)
        vc.view.addConstraints([
            rightView.view.topAnchor.constraint(equalTo: vc.view.topAnchor),
            rightView.view.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            rightView.view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])
        if let thumbnailUrl = thumbnailUrl {
            let leftView = UIViewController()
            leftView.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(vc)
            vc.view.addSubview(leftView.view)
            vc.view.addConstraints([
                leftView.view.topAnchor.constraint(equalTo: vc.view.topAnchor),
                leftView.view.rightAnchor.constraint(equalTo: rightView.view.leftAnchor, constant: -SkyStyles.Spacing.Content.Horizontal.Default),
                leftView.view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
                leftView.view.leftAnchor.constraint(equalTo: vc.view.leftAnchor)
            ])

            let imageView = UIImageView()
            imageView.load(url: thumbnailUrl)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            leftView.view.addSubview(imageView)
            leftView.view.addConstraints([
                imageView.topAnchor.constraint(equalTo: leftView.view.topAnchor),
                imageView.rightAnchor.constraint(equalTo: leftView.view.rightAnchor),
                imageView.bottomAnchor.constraint(equalTo: leftView.view.bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: leftView.view.leftAnchor)
                // Aspect-keeping width anchor is set upon image load
            ])

        } else {
            vc.view.addConstraint(rightView.view.leftAnchor.constraint(equalTo: vc.view.leftAnchor))
        }

        var totalHeight = 2 * SkyStyles.Spacing.Containers.Large

        let nameLabel = SkyLabel.createPageHeading(text: name)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        rightView.view.addSubview(nameLabel)
        rightView.view.addConstraints([
            nameLabel.topAnchor.constraint(equalTo: rightView.view.topAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: rightView.view.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: rightView.view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightView.view.trailingAnchor)
        ])
        totalHeight += nameLabel.intrinsicContentSize.height
        var lastLabel = nameLabel

        let lookupIdLabel = SkyLabel.createEmphasizedBodyCopy(text: "Lookup ID: \(lookupId)")
        lookupIdLabel.translatesAutoresizingMaskIntoConstraints = false
        rightView.view.addSubview(lookupIdLabel)
        rightView.view.addConstraints([
            lookupIdLabel.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.Separate),
            lookupIdLabel.bottomAnchor.constraint(lessThanOrEqualTo: rightView.view.bottomAnchor),
            lookupIdLabel.leadingAnchor.constraint(equalTo: rightView.view.leadingAnchor),
            lookupIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightView.view.trailingAnchor)
        ])
        totalHeight += lookupIdLabel.intrinsicContentSize.height + SkyStyles.Spacing.Content.Vertical.Separate
        lastLabel = lookupIdLabel

        if deceased || inactive {
            let text = deceased ? "Deceased" : "Inactive"
            let label = SkyLabel.createHeadline(text: text)
            label.translatesAutoresizingMaskIntoConstraints = false
            rightView.view.addSubview(label)
            rightView.view.addConstraints([
                label.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.Separate),
                label.bottomAnchor.constraint(lessThanOrEqualTo: rightView.view.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: rightView.view.leadingAnchor),
                label.trailingAnchor.constraint(lessThanOrEqualTo: rightView.view.trailingAnchor)
            ])
            totalHeight += label.intrinsicContentSize.height + SkyStyles.Spacing.Content.Vertical.Separate
            lastLabel = label
            return totalHeight
        }

        // Removing for now because we can't detect which piece was clicked so can't open an email compose or
        // open map directions. I've noted this and hope it will be enabled in a future SiriKit release.
//        if !email.isEmpty {
//            // T-ODO link
//            let label = SkyLabel(text: email)
//            label.translatesAutoresizingMaskIntoConstraints = false
//            rightView.view.addSubview(label)
//            rightView.view.addConstraints([
//                label.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.marginStackedSeparate),
//                label.bottomAnchor.constraint(lessThanOrEqualTo: rightView.view.bottomAnchor),
//                label.leadingAnchor.constraint(equalTo: rightView.view.leadingAnchor),
//                label.trailingAnchor.constraint(lessThanOrEqualTo: rightView.view.trailingAnchor)
//            ])
//            totalHeight += label.intrinsicContentSize.height + SkyStyles.Spacing.Content.Vertical.marginStackedSeparate
//            lastLabel = label
//        }

//        if !address.isEmpty {
//            // T-ODO link
//            let label = SkyLabel(text: address)
//            label.numberOfLines = 0
//            label.textAlignment = .left
//            label.translatesAutoresizingMaskIntoConstraints = false
//            rightView.view.addSubview(label)
//            rightView.view.addConstraints([
//                label.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: SkyStyles.Spacing.Content.Vertical.marginStackedSeparate),
//                label.bottomAnchor.constraint(lessThanOrEqualTo: rightView.view.bottomAnchor),
//                label.leadingAnchor.constraint(equalTo: rightView.view.leadingAnchor),
//                label.trailingAnchor.constraint(lessThanOrEqualTo: rightView.view.trailingAnchor)
//            ])
//            totalHeight += label.intrinsicContentSize.height + SkyStyles.Spacing.Content.Vertical.marginStackedSeparate
//            lastLabel = label
//        }

        return totalHeight

    }

    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }

}
