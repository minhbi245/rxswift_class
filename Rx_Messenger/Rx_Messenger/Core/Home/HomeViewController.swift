//
//  HomeViewController.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import UIKit

class HomeViewController: UIViewController {

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        displayUserInfo()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func displayUserInfo() {
        guard let user = UserModel.currentUser else { return }
        usernameLabel.text = "Username: \(user.username)"
        emailLabel.text = "Email: \(user.email)"
    }
}

