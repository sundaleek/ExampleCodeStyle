import UIKit

protocol ClassName {
    static func className() -> String
}

extension ClassName {
    static func className() -> String {
        String(describing: self)
    }
}

protocol ReusableView: AnyObject, ClassName {}

extension ReusableView {
    /// Идентификатор для реиспользования. Совпадает с названием класса.
    static var reuseIdentifier: String {
        className()
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
