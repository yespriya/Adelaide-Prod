//
//  LoaderManager.swift
//  Adelaide Prod
//
//  Created by Prit on 04/02/26.
//

import UIKit
import FLAnimatedImage

class LoaderManager {
    
    static let shared = LoaderManager()
    
    private let loaderTag = 789456123
    private var loaderShowTime: Date?
    private var latestLoaderToken: UUID?
    private let minimumVisibleDuration: TimeInterval = 0.6
    
    private init() {}
    
    // MARK: - Show Loader
    @discardableResult
    func activityIndicator(_ viewContainer: UIView, startAnimate: Bool? = true) -> FLAnimatedImageView {
        
        if startAnimate == true {
            return showLoader(in: viewContainer)
        } else {
            hideLoader(from: viewContainer)
            return FLAnimatedImageView()
        }
    }
    
    // MARK: - Show Loader Implementation
    private func showLoader(in viewContainer: UIView) -> FLAnimatedImageView {
        // Remove any existing loader first
        removeLoader(from: viewContainer)
        
        // Create main container
        let mainContainer = UIView(frame: viewContainer.bounds)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.black
        mainContainer.alpha = 0.8
        mainContainer.tag = loaderTag
        mainContainer.isUserInteractionEnabled = true
        
        // Create loader background view
        let viewBackgroundLoading = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.black
        viewBackgroundLoading.alpha = 1
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        // Create GIF animation view
        let animatedImageView = FLAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        animatedImageView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2,
                                           y: viewBackgroundLoading.frame.size.height / 2)
        
        // Load GIF from Assets
        if let gifDataAsset = NSDataAsset(name: "loading") {
            let animatedImage = FLAnimatedImage(animatedGIFData: gifDataAsset.data)
            animatedImageView.animatedImage = animatedImage
        }
        
        // Add views
        viewBackgroundLoading.addSubview(animatedImageView)
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        
        // Disable user interaction
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Track show time
        loaderShowTime = Date()
        latestLoaderToken = UUID()
        
        return animatedImageView
    }
    
    // MARK: - Hide Loader Implementation
    private func hideLoader(from viewContainer: UIView) {
        guard let showTime = loaderShowTime else {
            removeLoader(from: viewContainer)
            return
        }
        
        let elapsed = Date().timeIntervalSince(showTime)
        let remaining = max(0, minimumVisibleDuration - elapsed)
        let currentToken = latestLoaderToken
        
        DispatchQueue.main.asyncAfter(deadline: .now() + remaining) {
            if self.latestLoaderToken == currentToken {
                self.removeLoader(from: viewContainer)
            }
        }
    }
    
    // MARK: - Remove Loader
    private func removeLoader(from viewContainer: UIView) {
        for subview in viewContainer.subviews where subview.tag == loaderTag {
            // Stop GIF animation if needed
            if let gifContainer = subview.subviews.first?.subviews.first as? FLAnimatedImageView {
                gifContainer.animatedImage = nil
            }
            subview.removeFromSuperview()
        }
        
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        loaderShowTime = nil
    }
    
    // MARK: - Convenience Methods
    
    /// Show loader on key window
    func show() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            
            self.activityIndicator(window, startAnimate: true)
        }
    }
    
    /// Hide loader from key window
    func hide() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            
            self.activityIndicator(window, startAnimate: false)
        }
    }
}
