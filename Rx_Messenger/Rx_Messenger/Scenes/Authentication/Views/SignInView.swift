//
//  SignInView.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignInView: UIView {

    let disposeBag = DisposeBag()

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

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forget password?", for: .normal)
        button.setTitleColor(R.color.primaryColor(), for: .normal)
        button.titleLabel?.font = R.font.sfuiDisplayRegular(size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = R.color.primaryColor()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = R.font.sfuiDisplayRegular(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = R.font.sfuiDisplayRegular(size: 16)
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

        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20 // Thêm khoảng cách giữa các text field
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(forgotPasswordButton)
        addSubview(loginButton)
        addSubview(skipButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            forgotPasswordButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            skipButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func bind(to viewModel: LoginViewModel) {
        emailTextField.textField.rx.text.orEmpty.bind(to: viewModel.signInEmail).disposed(by: disposeBag)
        passwordTextField.textField.rx.text.orEmpty.bind(to: viewModel.signInPassword).disposed(by: disposeBag)
        loginButton.rx.tap.bind(to: viewModel.loginButtonTapped).disposed(by: disposeBag)
    }
}
