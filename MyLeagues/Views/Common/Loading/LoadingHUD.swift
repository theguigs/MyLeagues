//
//  LoadingHUD.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit

class LoadingHUD {
    private let window = with(UIWindow(frame: UIScreen.main.bounds)) {
        $0.windowLevel = .alert
    }

    let loadingView = with(LoadingView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private init() {
        loadingView.addTo(
            window,
            Pin(.center),
            Pin(.horizontal, .greaterThanOrEqual, constant: 50)
        )
    }

    static let shared = LoadingHUD()

    static func showDefaultLoader(
        animated: Bool = true
    ) {
        show(topViewMode: .loading, title: "Loading", animated: animated)
    }

    static func show(
        topViewMode: LoadingView.TopViewMode,
        title: String? = nil,
        subtitle: String? = nil,
        hideAfter: (duration: TimeInterval, animated: Bool, onHidden: (() -> Void)?)? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        let loadingHUD = LoadingHUD.shared
        loadingHUD.loadingView.configure(
            topViewMode: topViewMode, title: title, subtitle: subtitle
        )
        loadingHUD.window.alpha = 0
        loadingHUD.window.isHidden = false
        loadingHUD.loadingView.willAppear()

        UIView.animate(
            withDuration: animated ? 0.3 : 0,
            animations: {
                loadingHUD.window.alpha = 1
            },
            completion: { _ in
                completion?()
                if let (duration, animated, onHidden) = hideAfter {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        hide(animated: animated, completion: onHidden)
                    }
                }
            }
        )
    }

    static func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        let loadingHUD = LoadingHUD.shared

        UIView.animate(
            withDuration: animated ? 0.3 : 0,
            animations: {
                loadingHUD.window.alpha = 0
            },
            completion: { _ in
                loadingHUD.window.isHidden = true
                loadingHUD.loadingView.didDisappear()
                completion?()
            }
        )
    }
}
