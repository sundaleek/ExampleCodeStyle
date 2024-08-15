import UIKit

extension UITableView {
    /// Регистрирует класс ячейки для использования в `UITableView`
    ///
    /// - Parameter cellType: Тип ячейки, наследуемой от `UITableViewCell`
    func registerCellClass<T>(_ cellType: T.Type) where T: UITableViewCell {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    /// Регистрирует nib файл ячейки для использования в `UITableView`
    ///
    /// - Parameter cellType: Тип ячейки, которая реализует протокол `ReusableView`
    func registerCellNib<T>(_ cellType: T.Type) where T: UITableViewCell {
        let nib = UINib(nibName: cellType.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    /// Возвращает экземпляр переиспользуемой ячейки по ее типу.
    ///
    /// - Parameters:
    ///   - cellType: Тип ячейки (должна реализовывать протокол ReusableView).
    ///   - indexPath: Index path.
    /// - Returns: Экземпляр ячейки.
    func dequeueReusableCell<T>(ofType cellType: T.Type, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("❌ Не удалось найти ячейку с идентификатором \(cellType.reuseIdentifier)!")
        }
        return cell
    }

    // Регистрирует класс хедера/футера для использования в `UITableView`
    ///
    /// - Parameter cellType: Тип ячейки, наследуемой от `UITableViewCell`
    func registerHeaderFooterClass<T>(_ headerFooterType: T.Type) where T: UITableViewHeaderFooterView {
        register(headerFooterType, forHeaderFooterViewReuseIdentifier: headerFooterType.reuseIdentifier)
    }

    /// Регистрирует nib файл хедера/футера для использования в `UITableView`
    ///
    /// - Parameter cellType: Тип ячейки, которая реализует протокол `ReusableView`
    func registerHeaderFooterNib<T>(_ headerFooterType: T.Type) where T: UITableViewHeaderFooterView {
        let nib = UINib(nibName: headerFooterType.reuseIdentifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: headerFooterType.reuseIdentifier)
    }

    /// Возвращает экземпляр переиспользуемого хедера/футера по его типу.
    ///
    /// - Parameters:
    ///   - headerFooterType: Тип хедера/футера (должен реализовывать протокол ReusableView).
    /// - Returns: Экземпляр хедера/футера
    func dequeueReusableHeaderFooter<T>(ofType headerFooterType: T.Type) -> T where T: UITableViewHeaderFooterView {
        (dequeueReusableHeaderFooterView(withIdentifier: headerFooterType.reuseIdentifier) as? T) ?? headerFooterType.init()
    }
}

extension UICollectionView {
    /// Регистрирует класс ячейки для использования в `UICollectionView`
    ///
    /// - Parameter cellType: Тип ячейки, которая реализует протокол `ReusableView`
    func registerCellClass<T>(_ cellType: T.Type) where T: UICollectionViewCell {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    /// Регистрирует nib файл ячейки для использования в `UICollectionView`
    ///
    /// - Parameter cellType: Тип ячейки, которая реализует протокол `Reusable`
    func registerCellNib<T>(_ cellType: T.Type) where T: UICollectionViewCell {
        let nib = UINib(nibName: cellType.reuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    /// Возвращает экземпляр переиспользуемой ячейки по ее типу.
    ///
    /// - Parameters:
    ///   - cellType: Тип ячейки (должна реализовывать протокол ReusableView).
    ///   - indexPath: Index path.
    /// - Returns: Экземпляр ячейки.
    func dequeueReusableCell<T>(ofType cellType: T.Type, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("❌ Не удалось найти ячейку с идентификатором \(cellType.reuseIdentifier)!")
        }
        return cell
    }

    /// Регистрирует класс view для использования в `UICollectionReusableView`
    ///
    /// - Parameter viewType: Тип view, которая реализует протокол `ReusableView`
    func registerReusableClass<T>(_ viewType: T.Type, viewOfKind: String) where T: UICollectionReusableView {
        register(viewType, forSupplementaryViewOfKind: viewOfKind, withReuseIdentifier: viewType.reuseIdentifier)
    }

    /// Регистрирует nib файл ячейки для использования в `UICollectionReusableView`
    ///
    /// - Parameter viewType: Тип view, которая реализует протокол `ReusableView`
    func registerReusableNib<T>(_ viewType: T.Type, viewOfKind: String) where T: UICollectionReusableView {
        let nib = UINib(nibName: viewType.reuseIdentifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: viewOfKind, withReuseIdentifier: viewType.reuseIdentifier)
    }

    /// Возвращает экземпляр переиспользуемой view по ее типу.
    ///
    /// - Parameters:
    ///   - viewType: Тип view (должна реализовывать протокол ReusableView).
    ///   - indexPath: Index path.
    /// - Returns: Экземпляр view.
    func dequeueReusableView<T>(ofType viewType: T.Type, viewOfKind: String, at indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: viewOfKind,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            preconditionFailure("❌ Не удалось найти view с идентификатором \(viewType.reuseIdentifier)!")
        }
        return view
    }

    /// From Apple Docs:
    /// If you do not want a supplementary view in a particular case, your layout object should not create the attributes for that view. Alternatively, you
    /// can hide views by setting the isHidden property of the corresponding attributes to true or set the alpha property of the attributes to 0. To hide header
    /// and footer views in a flow layout, you can also set the width and height of those views to 0.
    /// - Parameters:
    ///     - indexPath: IndexPath
    /// - Returns: Invisible reusable view
    func dequeueEmptyReusableView(at indexPath: IndexPath) -> UICollectionReusableView {
        registerReusableClass(UICollectionReusableView.self, viewOfKind: UICollectionView.elementKindSectionHeader)

        let view = dequeueReusableView(
            ofType: UICollectionReusableView.self,
            viewOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        ).with {
            $0.frame.size.width = 0
            $0.frame.size.height = 0
        }

        return view
    }
}

extension UIView {
    func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
