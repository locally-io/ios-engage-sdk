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
        return MiscellaneousFullScreenContent(imageUrl: mediaImage?.url, title: headerTitle, interactiveContents: campaignContentButtons)
    }
}

class MiscellaneousImageViewController: UIViewController, Widget, InteractiveController {
    
    // MARK: - IBOutlets
    @IBOutlet private var titleOverlay: UILabel! {
        didSet {
            titleOverlay.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet private var overlayConstraint: NSLayoutConstraint!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var stackView: UIStackView!
    
    var transitionPercentage: UIViewControllerInteractiveTransitioning = UIPercentDrivenInteractiveTransition()
    
    private let threshold = CGFloat(0.95)
    
    private var didReachThreshold = false
    
    // MARK: - Public
    
    var didDismiss: (() -> Void)?
    
    var content: WidgetContent? {
        didSet {
            guard let miscellaneousContent = content as? MiscellaneousFullScreenContent else { return }
            createSubViews(withContent: miscellaneousContent)
        }
    }
    
    var id: Int? {
        didSet {
            
        }
    }
    
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
    }
    
    func prepareToPresent() {
        overlayConstraint.constant = -titleOverlay.height
        let animations = { self.view.layoutIfNeeded() }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: animations)
    }
    
    func didFinishPresenting() {
        
        overlayConstraint.constant = 0
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.0,
                       options: [.curveEaseOut],
                       animations: {
                        self.titleOverlay.alpha = 1
                        if self.stackView.tag == 0 {
                            self.stackView.isHidden = !self.stackView.isHidden
                        }
                        self.stackView.tag = 0
                        self.view.layoutIfNeeded()
        }, completion: { _ in
            self.showDismissalTutorial()
        })
    }
    
    // MARK: - Private Operations
    
    private func createSubViews(withContent content: MiscellaneousFullScreenContent) {
        
        if let imageUrl = content.imageUrl, let url = URL(string: imageUrl) {
            imageView.af_setImage(withURL: url)
        }
        
        titleOverlay.isHidden  = content.title == nil
        titleOverlay.text = content.title
        
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
        
        let request = getInteractiveRequest(content: interactiveContent)
        ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .interaction, forCampaign: request.action.rawValue))
        _ = InteractionServices.sendInteraction(request: request)
        switch interactiveContent.action {
        case .openUrl:
            guard let data = interactiveContent.data, let url = URL(string: data) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .phoneCall:
            guard let url = URL(string: "tel://\(String(describing: interactiveContent.data))") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .sendEmail: break
        case .openMap: break
        case .playVideo: break
        case .noAction: break
        }
    }
    
    private func getInteractiveRequest(content: InteractiveContent) -> InteractionsRequest {
        
        let campaignId = content.campaignId ?? 0
        let impressionId = content.impressionId ?? 0
        let deviceId = Utils.deviceId ?? ""
        let action = content.action
        let date = Utils.formatedDate
        return InteractionsRequest(campaignId: campaignId, impressionId: impressionId, deviceId: deviceId, action: action, timestamp: date)
    }
    
    private lazy var animator: UIViewPropertyAnimator = {
        let springParameters = UISpringTimingParameters(damping: 0.4, response: 0.3)
        let animator = UIViewPropertyAnimator(duration: 0.2, timingParameters: springParameters)
        return animator
    }()
    
    private func initializeAnimation() {
        
        didReachThreshold = false
        
        overlayConstraint.constant = -titleOverlay.height
        
        animator.addAnimations {
            self.titleOverlay.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            
            switch position {
            case .start:
                self.overlayConstraint.constant = 0
            case .end:
                self.overlayConstraint.constant = -self.titleOverlay.height
                
            case .current: break
            }
            
        }
        animator.startAnimation()
        animator.pauseAnimation()
    }
    
    @objc
    private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        
        guard let view = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        let percent = translation.y / view.height
        let maxPercentage = fmaxf(Float(percent), 0.0)
        let minPercentage = fminf(maxPercentage, 1.0)
        let progress = CGFloat(minPercentage)
        
        let percentDriven = (transitionPercentage as? UIPercentDrivenInteractiveTransition)
        
        switch gesture.state {
            
        case .began:
            initializeAnimation()
        case .changed:
            
            let fractionCompleted = animator.fractionComplete + progress
            
            didReachThreshold = fractionCompleted >= threshold
            
            animator.fractionComplete = fractionCompleted
            
            if didReachThreshold {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                dismiss(animated: true, completion: didDismiss)
                percentDriven?.finish()
            }
            
        case .cancelled:
            animator.stopAnimation(true)
            percentDriven?.cancel()
        case .ended:
            let fractionCompleted = animator.fractionComplete + progress
            
            didReachThreshold = fractionCompleted >= threshold
            
            animator.isReversed = !didReachThreshold
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
            if didReachThreshold {
                dismiss(animated: true, completion: didDismiss)
                stackView.isHidden = true
                stackView.tag = 1
                percentDriven?.finish()
            } else {
                percentDriven?.cancel()
            }
            
        default: break
        }
    }
    
    private func showDismissalTutorial() {
        
        view.addSubview(tapCircle)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: { [weak self] in
            
            guard let `self` = self else { return }
            
            self.tapCircle.y += 200
            self.tapCircle.layer.opacity = 0
            }, completion: { _ in
                self.tapCircle.removeFromSuperview()
        })
    }
}

extension UISpringTimingParameters {
    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
}
