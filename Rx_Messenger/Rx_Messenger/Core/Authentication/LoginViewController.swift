//
//  ViewController.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import UIKit
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
    
    // MARK: - DisposeBage
    let disposeBag = DisposeBag()
    
    // MARK: - UI Elements
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "LOGO"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["ĐĂNG KÝ", "ĐĂNG NHẬP"])
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let signUpView = SignUpView()
    private let signInView = SignInView()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupSegmentedControl()
        showSignInView() // Default view
        
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        
        headerView.addSubview(headerLabel)
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(segmentedControl)
        mainStackView.addArrangedSubview(containerView)
        
        containerView.addSubview(signUpView)
        containerView.addSubview(signInView)
    }
    
    private func setupConstraints() {
        // Main Stack View Constraints
        mainStackView.addConstraintsToFillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        
        // Header View Constraints
        headerView.setSizeConstraints(size: CGSize(width: 0, height: 150))
        
        // Header Label Constraints
        headerLabel.centerInSuperview()
        
        // Segmented Control Constraints
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // Container View Constraints
        containerView.setSizeConstraints(size: CGSize(width: 0, height: 300))
        
        // Sign Up View Constraints
        signUpView.addConstraintsToFillSuperview()
        
        // Sign In View Constraints
        signInView.addConstraintsToFillSuperview()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showSignUpView()
        } else {
            showSignInView()
        }
    }
    
    private func showSignUpView() {
        signUpView.isHidden = false
        signInView.isHidden = true
    }
    
    private func showSignInView() {
        signUpView.isHidden = true
        signInView.isHidden = false
    }
    
    private func bindViewModel() {
        // Sign Up View Model Binding
        signUpView.registerButtonTap()
            .subscribe(onNext: { user in
                print("Sign Up - User: \(user)")
                UserModel.currentUser = user
            })
            .disposed(by: disposeBag)
        
        // Sign In View Model Binding
        signInView.loginButtonTap()
            .subscribe(onNext: { [weak self] email, password in
                print("Sign In - Email: \(email), Password: \(password)")
                if self?.signInView.validateLogin(email: email, password: password) == true {
                    print("Login Successful")
                    self?.navigateToHomeScreen()
                } else {
                    print("Invalid Email or Password")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToHomeScreen() {
        let homeViewController = HomeViewController()
        homeViewController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true, completion: nil)
    }
}


