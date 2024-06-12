//
//  ViewController.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RswiftResources

class LoginViewController: UIViewController {

    // MARK: - DisposeBag
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
        view.backgroundColor = Color.primaryColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "LOGO"
        label.textColor = .white
        label.font = R.font.sfuiDisplayRegular(size: 40)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let customSegmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl(items: ["REGISTER", "LOGIN"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var signUpView = SignUpView()
    private lazy var signInView = SignInView()

    // MARK: - ViewModel
    private let viewModel: LoginViewModel
    private let coordinator: LoginCoordinator

    // MARK: - Initializers

    init(viewModel: LoginViewModel, coordinator: LoginCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupSegmentedControl()
        showSignInView() // Default view
        setupBindings()
    }

    // MARK: - Setup Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)

        headerView.addSubview(headerLabel)
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(customSegmentedControl)
        mainStackView.addArrangedSubview(containerView)

        containerView.addSubview(signUpView)
        containerView.addSubview(signInView)
    }

    private func setupConstraints() {
        // Main Stack View Constraints
        mainStackView.addConstraintsToFillSuperview(padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))

        // Header View Constraints
        headerView.setSizeConstraints(size: CGSize(width: 0, height: 150))

        // Header Label Constraints
        headerLabel.centerInSuperview()

        // Segmented Control Constraints
        customSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Container View Constraints
        containerView.setSizeConstraints(size: CGSize(width: 0, height: 300))

        // Sign Up View Constraints
        signUpView.addConstraintsToFillSuperview()

        // Sign In View Constraints
        signInView.addConstraintsToFillSuperview()
    }

    private func setupSegmentedControl() {
        customSegmentedControl.selectedSegmentIndex
            .subscribe(onNext: { [weak self] selectedIndex in
                if selectedIndex == 0 {
                    self?.showSignUpView()
                } else {
                    self?.showSignInView()
                }
            })
            .disposed(by: disposeBag)
    }

    private func showSignUpView() {
        signUpView.isHidden = false
        signInView.isHidden = true
    }

    private func showSignInView() {
        signUpView.isHidden = true
        signInView.isHidden = false
    }

    private func setupBindings() {
        // Bind Sign Up View
        signUpView.bind(to: viewModel)
        signUpView.registerButton.rx.tap
            .bind(to: viewModel.signUpButtonTapped)
            .disposed(by: disposeBag)

        // Bind Sign In View
        signInView.bind(to: viewModel)
        signInView.loginButton.rx.tap
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)

        // Subscribe to coordinator's output
        coordinator.output.subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loginSuccess:
                print("Login successful")
            case .loginFailure:
                print("Login failed")
            case .signUpSuccess:
                print("Sign up successful")
                self.showSignInView()
            case .signUpFailure:
                print("Sign up failed")
            }
        }).disposed(by: disposeBag)

        // Handle login button tap
        viewModel.loginButtonTapped
            .withLatestFrom(Observable.combineLatest(viewModel.signInEmail, viewModel.signInPassword))
            .subscribe(onNext: { [weak self] email, password in
                self?.coordinator.input.onNext(LoginCoordinatorInputEvent.loginRequested(email: email, password: password))
            }).disposed(by: disposeBag)

        // Handle sign up button tap
        viewModel.signUpButtonTapped
            .withLatestFrom(Observable.combineLatest(viewModel.name, viewModel.signUpEmail, viewModel.signUpPassword))
            .subscribe(onNext: { [weak self] name, email, password in
                self?.coordinator.input.onNext(LoginCoordinatorInputEvent.signUpRequested(name: name, email: email, password: password))
            }).disposed(by: disposeBag)
    }
}

