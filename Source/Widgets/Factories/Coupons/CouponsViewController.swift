//
//  CouponsViewController.swift
//  EngageSDK
//
//  Created by Rodolfo Pujol Luna on 04/04/19.
//  Copyright © 2019 Locally. All rights reserved.
//
import AlamofireImage
import AVFoundation
import UIKit

struct CouponsContent: WidgetContent {
    let imageUrl: String?
    let title: String?
    let qrUrl: String?
    let interactiveContents: [InteractiveContent]?
}

extension CampaignContent {
    var couponsContent: CouponsContent {
        return CouponsContent(imageUrl: mediaImage?.url, title: headerTitle,
                              qrUrl: qrCodeImageUrl, interactiveContents: campaignContentButtons)
    }
}

class CouponsViewController: UIViewController, Widget, InteractiveController {
    
    // MARK: - IBOutlets
    @IBOutlet private var titleOverlay: UILabel! {
        didSet {
            titleOverlay.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet private var titleConstraint: NSLayoutConstraint!
    @IBOutlet private var pictureView: UIImageView!
    @IBOutlet private var qrView: UIImageView!
    @IBOutlet private var stackView: UIStackView!
    
    var transitionPercentage: UIViewControllerInteractiveTransitioning = UIPercentDrivenInteractiveTransition()
    
    private let threshold = CGFloat(0.95)
    
    private var didReachThreshold = false
    
    // MARK: - Public
    
    var didDismiss: (() -> Void)?
    
    var content: WidgetContent? {
        didSet {
            guard let couponContent = content as? CouponsContent else { return }
            createSubViews(withContent: couponContent)
        }
    }
    
    var id: Int?
    
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
        titleConstraint.constant = -titleOverlay.height
        let animations = { self.view.layoutIfNeeded() }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: animations)
    }
    
    func didFinishPresenting() {
        
        titleConstraint.constant = 0
        
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
    private func createSubViews(withContent content: CouponsContent) {
        
        if let imageUrl = content.imageUrl, let url = URL(string: imageUrl) {
            pictureView.af_setImage(withURL: url)
        }
        
        if let couponUrl = content.qrUrl, let qrUrl = URL(string: couponUrl) {
            qrView.af_setImage(withURL: qrUrl)
        }
        
        titleOverlay.isHidden  = content.title == nil
        titleOverlay.text = content.title
        
        if let interactiveContents = content.interactiveContents {
            setupButtonsbar(withInteractiveContents: interactiveContents)
        }
    }
    
    func present() -> Bool {
        return false
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
        
        guard let couponContent = content as? CouponsContent else { return }
        
        guard let interactiveContent = couponContent.interactiveContents?[sender.tag] else { return }
        
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
        let springParameters = UISpringTimingParameters(dampingRatio: 0.4, initialVelocity: CGVector(dx: 0.3, dy: 0.3))
        let animator = UIViewPropertyAnimator(duration: 0.2, timingParameters: springParameters)
        return animator
    }()
    
    private func initializeAnimation() {
        
        didReachThreshold = false
        titleConstraint.constant = -titleOverlay.height
        animator.addAnimations {
            self.titleOverlay.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            switch position {
            case .start:
                self.titleConstraint.constant = 0
            case .end:
                self.titleConstraint.constant = -self.titleOverlay.height
                
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
