Правила и подходы которые не зафиксированы в SwiftLint/SwiftFormat на текущий момент или не могут быть зафиксированы там.



###### Процесс

Используем [Trunk Based Development](https://trunkbaseddevelopment.com). Весь код добавляется в master только через Merge Request (MR)

Задачки в Jira переносим сами пока не работает автоматический перенос по открытию/закрытию MR в GitLab. В задачках в колонке Ready for Test, человек который собирает сборку, проставляет build number после того как он (билд) был создан, опять же пока это не автоматизировано. После того как задача оттестирована она попадает в Done.

Каждую неделю проводим груминг задач в бэклоге, чтобы все понимали что будет делаться и любой мог взять соответствующую задачу из спринта, а также понимать больше контекста при проведении code review.

###### Архитектура

Используем MVVM. 

###### Роутинг

В новом коде следует использовать AppRouter непосредственно из ViewModel. Для legacy кода, допустимо продолжать использовать AppRouter из View/ViewController, если перенос во ViewModel слишком трудозатратен. При выполнении задач рефакторинга legacy кода, вызов AppRouter должен быть перенесен во ViewController.

###### Шаблон для View

```swift
// Copyright (c) 2024 DEV_COMPANY_NAME. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ACustomView: UIView, UITextFieldDelegate {
    // Если требуется использовать Rx, то view должна содержать свой disposeBag
    // в коде имеются места с разным именованием свойства, содержащего DisposeBag
    // предпочтительней использовать `bag`
    private let bag = DisposeBag()

    // Простая view объявляется так
    private lazy var titleLabel = UILabel()
    // или так
    private let actionButton = UIButton()
    
    // View для которой требуется настройка дополнительных свойств объявляется так
    // UIView().with {...} — неправильно
    // let для такого объявления тоже можно использовать
    private lazy var subviewWithConfig = UIView {
        $0.backgroundColor = .white
    }
    
    // View для которой требуется передать параметры в init (e.g.: UIButton, UITableView, UICollectionView) объявляется так
    // если view требуется использовать в реактивном расширении, можно сделать ее fileprivate
    // let для такого объявления тоже можно использовать
    fileprivate lazy var button = UIButton(type: .custom).with {
        $0.setBackgroundImage(.icCloseButton, for: .normal)
    }
    
    // Дефолтный инит оверрайдится так:
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        // Инициализация внутренних свойств view происходит тут, если их не много
        // в ином случае выносим в отдельную функцию setup() в private extension рядом с makeConstraints()
        backgroundColor = .white
       
        // Описание layout и добавление View выносится в отдельную функцию
        makeConstraints()
        // Реактивные биндинги внутри view выносятся в отдельную приватную функцию
        setupBindings()
    }

    // Мы не используем Interface Builder
    // Если View используется в легаси коде и подключается к нему через xib, storyboard, то делается общая приватная функция
    // commonInit() в private extension, в которую выносится все что описано выше в init
  	// и далее эта функция вызывается из init(frame:) и init?(coder:)
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    // Т.к. любая view может быть переиспользована в других модулях и может быть вынесена в отдельный Framework,
    // то желательно добавлять публичный метод инциализации данными View некоторой моделью объявленной в namespace данной конкретной view
    func configure(with model: Model) {
        simpleSubview.text = model.text
    }
}

public extension ACustomView {
    // Модель может быть как структурой, так и enum'ом
    struct Model {
        let text: String
    }
}

public extension Reactive where Base == ACustomView {
    // События генерируемые внутренними subview должны быть вынесены в реактивные обёртки
    // например событие нажатие на кнопку
  	// Нажатие на кнопки, вью и т.д. должно иметь тип ControlEvent<Void>, чтобы соответствовать заложенным в RxCocoa паттернам
    var buttonTap: ControlEvent<Void> {
        base.button.rx.tap
    }
    
    // Для переменных параметров view необходимо создавать binder'ы
    var model: Binder<Base.Model> {
        Binder(base) { view, model in
            view.configure(with: model)
        }
    }
}

private extension ACustomView {
    func makeConstraints() {
        // добавление сабвью происходит так, что обеспечивает видимую иерархию сабвью непосредственно в коде
        // для UIStackView добавление arrangedSubviews происходит так же если они формируются не на основе модели
        addSubviews(
            subviewWithConfig.addSubviews(
                simpleSubview
            ),
            button
        )
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .vertical)

        // общие константы определяем заранее чтобы не дублировать
        let containerInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        simpleSubview.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // в качестве параметра closure вызова makeConstraints используется make
        // т.о. само описание constraint'а превращается в легко читаемую английскую фразу
        simpleSubview.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(containerInsets).priority(.high)
            make.leading.equalToSuperview().inset(containerInsets).priority(.high) // используем leading, trailing вмест right, left
            make.height.equalTo(40).priority(.high) // константы можно использовать прямо тут
        }
    }

    // Если View может каким-то образом реагировать на действия пользователя не включая бизнес логики
    // например:
    //  - кнопка сброса введенного тектса textField (viewModel все равно увидит изменения text)
    //  - скрытие/показ каких-то subview
    //  - и т.д.;
    // то делаем это непосредственно во view c помощью Rx
    func setupBindings() {
        button.rx.tap
            .bind(onNext: { [simpleSubview] in
                simpleSubview.isHidden.toggle() // так делаеть необязательно =)
            })
            .disposed(by: disposeBag)
    }
}

```



