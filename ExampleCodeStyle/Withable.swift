import Foundation
import UIKit

protocol Withable {
    init()
}

extension Withable {
    init(with configure: (inout Self) -> Void) {
        self.init()
        configure(&self)
    }

    func with(_ configure: (inout Self) -> Void) -> Self {
        var copy = self
        configure(&copy)
        return copy
    }
}

extension UIView: Withable {}
extension UINavigationItem: Withable {}
extension UICollectionViewLayout: Withable {}
extension UIEdgeInsets: Withable {}
extension CGSize: Withable {}
extension CGRect: Withable {}
extension CGPoint: Withable {}
extension UIGestureRecognizer: Withable {}
extension UIBarItem: Withable {}
extension NSMutableParagraphStyle: Withable {}

extension MeasurementFormatter: Withable {}
extension NumberFormatter: Withable {}
extension DateFormatter: Withable {}

extension UIView {
    @discardableResult
    func addSubviews(_ subviews: UIView...) -> Self {
        subviews.forEach(addSubview)
        return self
    }
}

public extension UIStackView {
    @discardableResult
    func addArrangedSubviews(_ views: UIView...) -> UIView {
        views.forEach(addArrangedSubview)
        return self
    }

    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> UIView {
        views.forEach(addArrangedSubview)
        return self
    }

    func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func arrangedSubviews<T: UIView>() -> [T] {
        arrangedSubviews.compactMap { $0 as? T }
    }
}

