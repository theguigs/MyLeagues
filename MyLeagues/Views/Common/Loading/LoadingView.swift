//
//  LoadingView.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit
import SwiftUI

import ActivityIndicatorView

final class LoadingView: UIView {
    lazy var newContentView = with(UIVisualEffectView(effect: UIBlurEffect(style: .regular))) {
        stackView.addTo($0.contentView, Pin(.all, constant: StyleSheet.Margins.xLarge))
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 35
    }
    lazy var contentView = with(UIView(translateMasksToConstraints: false)) {
        newContentView.addTo($0, Pin(.all))

        $0.backgroundColor = .clear
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowOffset = .init(width: 0, height: 4)
    }
    lazy var stackView = with(UIStackView(arrangedSubviews: [
        topViewContainer,
        titleView,
        subTitleView
    ])) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = StyleSheet.Margins.xSmall
        $0.alignment = .center
    }

    lazy var topViewContainer = UIView()
    lazy var titleView = with(UILabel()) {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: StyleSheet.FontSize.large, weight: .medium)
        $0.textColor = Colors.grey0
    }
    lazy var subTitleView = with(UILabel()) {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: StyleSheet.FontSize.medium, weight: .regular)
        $0.textColor = Colors.grey1
    }

    lazy var checkView = with(UIImageView(image: .init(systemName: "checkmark.circle"))) {
        $0.contentMode = .center
    }
    lazy var loadingView = with(UIActivityIndicatorView(style: .medium)) {
        $0.startAnimating()
        $0.color = .white
    }

    init() {
        super.init(frame: .zero)
                
        contentView.addTo(self, Pin(.all))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(topViewMode: TopViewMode, title: String?, subtitle: String?) {
        configure(topView: view(for: topViewMode), title: title, subtitle: subtitle)
    }
    
    func configure(topView: UIView, title: String?, subtitle: String?) {
        topViewContainer.subviews.forEach { $0.removeFromSuperview() }
        
        topView.addTo(topViewContainer, Pin(.all))
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.withSize(w: 75, h: 75)
        
        if let title {
            titleView.text = title
        }
        
        if let subtitle {
            subTitleView.text = subtitle
        }
        
        titleView.isHidden = title == nil
        subTitleView.isHidden = subtitle == nil
    }

    func view(for topViewMode: TopViewMode) -> UIView {
        switch topViewMode {
        case .check: return checkView
        case .loading:
            let view = ActivityIndicatorView(isVisible: .constant(true), type: .rotatingDots())
                .foregroundColor(Color(Colors.grey0))
            let v = UIHostingController(rootView: view)
            v.view.backgroundColor = .clear
            return v.view
        }
    }

    func willAppear() {
        if loadingView.superview != nil {
            loadingView.startAnimating()
        }
    }
    func didDisappear() {
        if loadingView.isAnimating {
            loadingView.stopAnimating()
        }
    }

    enum TopViewMode {
        case check
        case loading
    }
}
