//
//  SignUpView.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpView: UIView {

    let disposeBag = DisposeBag()

    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField(image: R.image.profile_icon(), placeholder: "Full Name")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(image: R.image.email_icon(), placeholder: "Email")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(image: R.image.password_icon(), placeholder: "Password")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("REGISTER", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = R.color.primaryColor()
        button.titleLabel?.font = R.font.sfuiDisplayRegular(size: 16)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(registerButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            registerButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func bind(to viewModel: LoginViewModel) {
        nameTextField.textField.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: disposeBag)
        emailTextField.textField.rx.text.orEmpty.bind(to: viewModel.signUpEmail).disposed(by: disposeBag)
        passwordTextField.textField.rx.text.orEmpty.bind(to: viewModel.signUpPassword).disposed(by: disposeBag)
        registerButton.rx.tap.bind(to: viewModel.signUpButtonTapped).disposed(by: disposeBag)
    }
}
