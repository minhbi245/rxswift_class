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
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mật khẩu"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Quên mật khẩu", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ĐĂNG NHẬP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bỏ qua", for: .normal)
        button.setTitleColor(.purple, for: .normal)
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
        
        let emailFieldContainer = createFieldContainer(iconName: "envelope.circle", textField: emailTextField)
        let passwordFieldContainer = createFieldContainer(iconName: "lock.circle", textField: passwordTextField)
        
        let stackView = UIStackView(arrangedSubviews: [emailFieldContainer, passwordFieldContainer])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
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
            
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            skipButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func createFieldContainer(iconName: String, textField: UITextField) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .purple
        
        container.addSubview(iconImageView)
        container.addSubview(textField)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textField.topAnchor.constraint(equalTo: container.topAnchor),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        return container
    }
    
    func loginButtonTap() -> Observable<(String, String)> {
        return loginButton.rx.tap
            .withLatestFrom(Observable.combineLatest(emailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty))
            .asObservable()
    }
    
    func validateLogin(email: String, password: String) -> Bool {
        guard let user = UserModel.currentUser else { return false }
        return email == user.email && password == user.password
    }
}
