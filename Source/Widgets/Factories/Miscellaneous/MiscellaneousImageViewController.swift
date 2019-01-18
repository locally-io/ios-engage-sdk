//
//  MiscellaneousImageViewController.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 7/11/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import AlamofireImage
import UIKit

struct MiscellaneousFullScreenContent: WidgetContent {
	let imageUrl: String?
	let title: String?
	let interactiveContents: [InteractiveContent]?
}

extension CampaignContent {
	var miscellaneousFullScreenContent: MiscellaneousFullScreenContent {
		return MiscellaneousFullScreenContent(imageUrl: mediaImage?.url, title: name, interactiveContents: campaignContentButtons)
	}
}

class MiscellaneousImageViewController: UIViewController, Widget {

	// MARK: - Public

	var content: WidgetContent? {
		didSet {
			guard let miscellaneousContent = content as? MiscellaneousFullScreenContent else { return }
			createSubViews(withContent: miscellaneousContent)
		}
	}

	private var scheduler: Scheduler?

	// MARK: - Subviews

	@IBOutlet private var imageView: UIImageView!

	@IBOutlet private var titleOverlay: UILabel! {
		didSet {
			titleOverlay.backgroundColor = ColorPalette.blackOverlay
		}
	}

	@IBOutlet private var stackView: UIStackView!

	// MARK: - Private Properties

	private lazy var tapCircle: UIView = {
		let circle = UIView(frame: .zero)
		circle.width = 40
		circle.height = 40
		circle.x = view.halfWidth - circle.halfWidth
		circle.y = 110
		circle.layer.cornerRadius = circle.halfWidth
		circle.backgroundColor = ColorPalette.green
		circle.layer.opacity = 0.5
		circle.layer.shadowOpacity = 0.3
		circle.layer.shadowOffset = CGSize()

		return circle
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
		view.addGestureRecognizer(gesture)

		scheduler = Scheduler.runOnce(delay: 1) { _ in
			DispatchQueue.main.async {
				self.showDismissalTutorial()
			}
		}
	}

	// MARK: - Private Operations

	private func createSubViews(withContent content: MiscellaneousFullScreenContent) {

		if let imageUrl = content.imageUrl, let url = URL(string: imageUrl) {
			imageView.af_setImage(withURL: url)
		}

		if let title = content.title {
			titleOverlay.text = title
			titleOverlay.isHidden = false
		}

		if let interactiveContents = content.interactiveContents {
			setupButtonsbar(withInteractiveContents: interactiveContents)
		}
	}

	private func setupButtonsbar(withInteractiveContents interactiveContents: [InteractiveContent]) {

		for (index, interactiveContent) in interactiveContents.enumerated() {

			guard let label = interactiveContent.label, !label.isEmpty else { continue }

			let button = newButton()
			button.setTitle(interactiveContent.label, for: .normal)
			button.setTitle(interactiveContent.label, for: .selected)
			button.tag = index

			stackView.addArrangedSubview(button)
		}
	}

	private func newButton() -> UIButton {
		let button = UIButton()
		button.clipsToBounds = true
		button.layer.cornerRadius = 5
		button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
		button.backgroundColor = ColorPalette.green
		button.titleLabel?.lineBreakMode = .byTruncatingTail
		button.height = 50
		button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

		return button
	}

	@objc
	private func didTapButton(sender: UIButton) {

		guard let miscellaneousContent = content as? MiscellaneousFullScreenContent else { return }

		guard let interactiveContent = miscellaneousContent.interactiveContents?[sender.tag] else { return }

		switch interactiveContent.action {

			case .openUrl:
				guard let url = URL(string: interactiveContent.data) else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			case .phoneCall:
				guard let url = URL(string: "tel://\(interactiveContent.data)") else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			case .sendEmail: break
			case .openMap: break
			case .playVideo: break
			case .noAction: break
		}
	}

	@objc
	private func panGestureHandler(_ panGesture: UIPanGestureRecognizer) {

		let velocity = panGesture.velocity(in: view)

		switch panGesture.state {
			case .changed where velocity.y > 1200:
				dismiss(animated: true, completion: nil)
			default: break
		}
	}

	private func showDismissalTutorial() {

		view.addSubview(tapCircle)

		UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: { [weak self] in

			guard let `self` = self else { return }

			self.tapCircle.y += 200
			self.tapCircle.layer.opacity = 0
		}, completion: { _ in
			self.tapCircle.removeFromSuperview()
		})
	}
}
