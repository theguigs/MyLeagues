//
//  UIView+Extensions.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import UIKit

extension UIView {
    convenience init(translateMasksToConstraints: Bool) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = translateMasksToConstraints
    }

    func fixWidth(_ constant: CGFloat) -> NSLayoutConstraint {
        return widthAnchor.constraint(equalToConstant: constant)
    }
    func fixHeight(_ constant: CGFloat) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalToConstant: constant)
    }
}

extension NSLayoutConstraint {
    typealias Axes = Set<Axis>
    typealias Attributes = Set<Attribute>
}

extension NSLayoutConstraint.Axes {
    static let all: NSLayoutConstraint.Axes = [.horizontal, .vertical]
    static let horizontal: NSLayoutConstraint.Axes = [.horizontal]
    static let vertical: NSLayoutConstraint.Axes = [.vertical]

    var isHorizontal: Bool { contains(.horizontal) }
    var isVertical: Bool { contains(.vertical) }
}

extension NSLayoutConstraint.Attributes {
    static let all: NSLayoutConstraint.Attributes = [.top, .bottom, .leading, .trailing]
    static let horizontal: NSLayoutConstraint.Attributes = [.leading, .trailing]
    static let vertical: NSLayoutConstraint.Attributes = [.top, .bottom]
    static let size: NSLayoutConstraint.Attributes = [.width, .height]
    static let top: NSLayoutConstraint.Attributes = [.top]
    static let bottom: NSLayoutConstraint.Attributes = [.bottom]
    static let leading: NSLayoutConstraint.Attributes = [.leading]
    static let trailing: NSLayoutConstraint.Attributes = [.trailing]
    static let width: NSLayoutConstraint.Attributes = [.width]
    static let height: NSLayoutConstraint.Attributes = [.height]
    static let center: NSLayoutConstraint.Attributes = [.centerX, .centerY]
    static let centerX: NSLayoutConstraint.Attributes = [.centerX]
    static let centerY: NSLayoutConstraint.Attributes = [.centerY]

    static let allButTop: NSLayoutConstraint.Attributes = [.bottom, .leading, .trailing]
    static let allButBottom: NSLayoutConstraint.Attributes = [.top, .leading, .trailing]
    static let allButLeading: NSLayoutConstraint.Attributes = [.top, .bottom, .trailing]
    static let allButTrailing: NSLayoutConstraint.Attributes = [.top, .bottom, .leading]
}

extension UIView {
    struct MarginSet {
        let t, b, l, r: Bool

        static let horizontal = MarginSet(t: false, b: false, l: true, r: true)
        static let vertical = MarginSet(t: true, b: true, l: false, r: false)
        static let all = MarginSet(t: true, b: true, l: true, r: true)
        static let none = MarginSet(t: false, b: false, l: false, r: false)
    }
}

// Create UILayoutPriorities with just an integer literal.
// eg. myConstraint.priority = 1000
extension UILayoutPriority: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self = UILayoutPriority(Float(value))
    }
}

extension NSLayoutConstraint {
    @discardableResult
    func withPriority(_ p: UILayoutPriority?) -> NSLayoutConstraint {
        if let p = p { priority = p }
        return self
    }

    convenience init(item: Any, attribute: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation, constant c: CGFloat) {
        self.init(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: c)
    }
}

// Shorthand for translatesAutoresizingMaskIntoConstraints

extension UIView {
    var autolayout: Bool {
        get { !translatesAutoresizingMaskIntoConstraints }
        set { translatesAutoresizingMaskIntoConstraints = !newValue }
    }

    @discardableResult
    func autolaidout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

// Hugging and compression resistance

extension UIView {
    @discardableResult
    func hugged(_ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required) -> Self {
        if axes.isHorizontal { setContentHuggingPriority(priority, for: .horizontal) }
        if axes.isVertical { setContentHuggingPriority(priority, for: .vertical) }
        return self
    }

    @discardableResult
    func incompressible(_ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required) -> Self {
        if axes.isHorizontal { setContentCompressionResistancePriority(priority, for: .horizontal) }
        if axes.isVertical { setContentCompressionResistancePriority(priority, for: .vertical) }
        return self
    }
}

// Fixing width and height

extension UIView {

    @discardableResult
    func withSize(_ fixedSize: CGSize, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, constant: fixedSize.width).withPriority(priority))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, constant: fixedSize.height).withPriority(priority))
        return self
    }

    @discardableResult
    func withSize(w width: CGFloat, h height: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, constant: width).withPriority(priority))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, constant: height).withPriority(priority))
        return self
    }

    @discardableResult
    func withWidth(_ width: CGFloat, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: relation, constant: width).withPriority(priority))
        return self
    }

    @discardableResult
    func withHeight(_ height: CGFloat, _ relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: relation, constant: height).withPriority(priority))
        return self
    }

}

// Centering in superview

extension UIView {
    @discardableResult
    func centeredInSuperview(_ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required, avoidingOverflow: UILayoutPriority? = nil) -> Self {
        guard let s = superview else { return self }

        if axes.isHorizontal {
            s.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: s, attribute: .centerX, multiplier: 1, constant: 0).withPriority(priority))

            if let op = avoidingOverflow {
                s.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: s, attribute: .left, multiplier: 1, constant: 0).withPriority(op))
            }
        }

        if axes.isVertical {
            s.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: s, attribute: .centerY, multiplier: 1, constant: 0).withPriority(priority))

            if let op = avoidingOverflow {
                s.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: s, attribute: .top, multiplier: 1, constant: 0).withPriority(op))
            }
        }

        return self
    }

    @discardableResult
    func addAndCenterIn(_ superview: UIView, _ axes: NSLayoutConstraint.Axes = .all, priority: UILayoutPriority = .required, avoidingOverflow: UILayoutPriority? = nil) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        return centeredInSuperview(axes, priority: priority, avoidingOverflow: avoidingOverflow)
    }
}

// Pinning in a view

extension UIView {
    // Returns the superview
    @discardableResult
    func addedTo<T: UIView>(_ superview: T, _ pins: Pin...) -> T {
        self.addTo(superview, pins)
        return superview
    }

    // Returns self
    @discardableResult
    func addTo(_ superview: UIView, _ pins: Pin...) -> Self {
        return self.addTo(superview, pins)
    }

    // Returns self
    @discardableResult
    func addTo(_ superview: UIView, _ pins: [Pin]) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)

        NSLayoutConstraint.activate(pins.flatMap { pin in pin.attributes.compactMap { attr -> NSLayoutConstraint? in
            switch (attr, pin.relation) {
            case (.leading, .equal):
                return leadingAnchor.constraint(equalTo: pin.type.guide(for: superview)?.leadingAnchor ?? superview.leadingAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.leading, .greaterThanOrEqual):
                return leadingAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.leadingAnchor ?? superview.leadingAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.leading, .lessThanOrEqual):
                return leadingAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.leadingAnchor ?? superview.leadingAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.trailing, .equal):
                return trailingAnchor.constraint(equalTo: pin.type.guide(for: superview)?.trailingAnchor ?? superview.trailingAnchor, constant: -pin.constant).withPriority(pin.priority)
            case (.trailing, .greaterThanOrEqual):
                return trailingAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.trailingAnchor ?? superview.trailingAnchor, constant: -pin.constant).withPriority(pin.priority)
            case (.trailing, .lessThanOrEqual):
                return trailingAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.trailingAnchor ?? superview.trailingAnchor, constant: -pin.constant).withPriority(pin.priority)
            case (.top, .equal):
                return topAnchor.constraint(equalTo: pin.type.guide(for: superview)?.topAnchor ?? superview.topAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.top, .greaterThanOrEqual):
                return topAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.topAnchor ?? superview.topAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.top, .lessThanOrEqual):
                return topAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.topAnchor ?? superview.topAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.bottom, .equal):
                return bottomAnchor.constraint(equalTo: pin.type.guide(for: superview)?.bottomAnchor ?? superview.bottomAnchor, constant: -pin.constant).withPriority(pin.priority)
            case (.bottom, .greaterThanOrEqual):
                return bottomAnchor.constraint(lessThanOrEqualTo: pin.type.guide(for: superview)?.bottomAnchor ?? superview.bottomAnchor, constant: -pin.constant).withPriority(pin.priority)
            case (.bottom, .lessThanOrEqual):
                return bottomAnchor.constraint(greaterThanOrEqualTo: pin.type.guide(for: superview)?.bottomAnchor ?? superview.bottomAnchor, constant: -pin.constant).withPriority(pin.priority)
            case (.centerX, .equal):
                return centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: pin.constant).withPriority(pin.priority)
            case (.centerY, .equal):
                return centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: pin.constant).withPriority(pin.priority)
            default:
                return nil
            }
        }})

        return self
    }
}

// Margins for subviews of UIStackView
extension UIView {
    func setCustomSpacingBefore(_ spacing: CGFloat) {
        guard let stack = superview as? UIStackView,
              let myIndex = stack.arrangedSubviews.firstIndex(of: self),
              myIndex > 0
        else { return }

        stack.setCustomSpacing(spacing, after: stack.arrangedSubviews[myIndex - 1])
    }

    func setCustomSpacingAfter(_ spacing: CGFloat) {
        guard let stack = superview as? UIStackView else { return }
        stack.setCustomSpacing(spacing, after: self)
    }
}

enum PinType {
    case safe
    case margin
    case readable
    case absolute

    func guide(for view: UIView) -> UILayoutGuide? {
        switch self {
        case .safe: return view.safeAreaLayoutGuide
        case .margin: return view.layoutMarginsGuide
        case .readable: return view.readableContentGuide
        default: return nil
        }
    }
}

struct Pin {
    let attributes: NSLayoutConstraint.Attributes
    let type: PinType
    let constant: CGFloat
    let relation: NSLayoutConstraint.Relation
    let priority: UILayoutPriority?

    init(_ attributes: NSLayoutConstraint.Attributes, to type: PinType = .safe, _ relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = 0, priority: UILayoutPriority? = nil) {
        self.attributes = attributes
        self.type = type
        self.relation = relation
        self.constant = constant
        self.priority = priority
    }
}
