//
//  ViewController.swift
//  ExampleCodeStyle
//
//  Created by Mac on 8/15/24.
//

import UIKit
//typelalias loc = R.string.localizable.self

class ViewController: VC {
    
    //верстку пишем в контроллере
    //viewModel не используем
    //каждый UI компонент конфигурирем при инициализации
    //любое последующее изменение UI компонента делается
    //через view.configure(with: model)
    //где model - это внутренняя моделька
    //под каждую вью создается своя моделька
    //это нужно для того чтобы после написания верстки
    //например при написании бизнес логики
    //разработчик ни в каком виде не соприкасался с UI частью
    //а работал напрямую с этими модельками
    private let button = CustomButton {
        //все строки выносим в Localizable
        //вызываем через R.swift
        //например loc.buttonTitle()
        //прим ред loc это глобальная переменная см 9 строку
        $0.setTitle("Button title", for: .normal)
    }
    
    internal override func setupViews() {
        view.backgroundColor = .blue
        view.addSubviews(
            button
        )
        /*
         button.snp.makeConstraints { make in
            make.center.equalToSuperView()
            make.size.equalTo(100)
         }
         */
    }
    
    internal override func setupActions() {
        ///add some actions here
    }


}

