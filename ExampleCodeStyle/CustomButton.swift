//
//  CustomButton.swift
//  ExampleCodeStyle
//
//  Created by Mac on 8/15/24.
//

import UIKit

final class CustomButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {}
    private func setupActions() {}
    
    private func configure(with model: Model) {
        setTitle(model.title, for: .normal)
    }
}

extension CustomButton {
    struct Model {
        let title: String
    }
}
