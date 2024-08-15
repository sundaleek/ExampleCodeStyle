import UIKit
//import RxSwift

class VC: UIViewController {
//    let bag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {}
    func setupActions() {}
}

final class CustomVC: VC {
    override func setupViews() {
        print("hello world", #line, #function)
    }
    override func setupActions() {
        print("hello world", #line, #function)
    }
}

class CustomView: UIView {
//    let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
    func setupActions() {}
}

