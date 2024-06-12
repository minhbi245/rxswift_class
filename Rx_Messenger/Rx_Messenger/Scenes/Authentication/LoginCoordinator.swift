//
//  LoginCoordinator.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginCoordinator: NavigationCoordinator<AppRoute> {

    private let userUseCase: UserUseCase
    private let disposeBag = DisposeBag()

    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        super.init(initialRoute: .home)
        bindInput()
    }

    override func prepareTransition(for route: Route) -> NavigationTransition {
        guard let route = route as? AppRoute else { return .none }
        switch route {
        case .home:
            let homeViewModel = HomeViewModel(userUseCase: userUseCase)
            let homeViewController = HomeViewController(viewModel: homeViewModel)
            return .push(homeViewController)
        default:
            return .none
        }
    }

    override func start() {
        let loginViewModel = LoginViewModel(userUseCase: userUseCase)
        let loginViewController = LoginViewController(viewModel: loginViewModel, coordinator: self)
        navigationController?.pushViewController(loginViewController, animated: false)
    }

    private func bindInput() {
        input.subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loginRequested(let email, let password):
                self.handleLogin(email: email, password: password)
            case .signUpRequested(let name, let email, let password):
                self.handleSignUp(name: name, email: email, password: password)
            }
        }).disposed(by: disposeBag)
    }

    private func handleLogin(email: String, password: String) {
        userUseCase.loginUser(email: email, password: password)
            .subscribe(onSuccess: { [weak self] success in
                if success {
                    self?.output.onNext(LoginCoordinatorOutputEvent.loginSuccess)
                    self?.navigate(to: AppRoute.home)
                } else {
                    self?.output.onNext(LoginCoordinatorOutputEvent.loginFailure)
                }
            }, onFailure: { [weak self] _ in
                self?.output.onNext(LoginCoordinatorOutputEvent.loginFailure)
            }).disposed(by: disposeBag)
    }

    private func handleSignUp(name: String, email: String, password: String) {
        let user = UserModel(email: email, username: name, password: password)
        userUseCase.registerUser(user: user)
            .subscribe(onCompleted: { [weak self] in
                self?.output.onNext(LoginCoordinatorOutputEvent.signUpSuccess)
            }, onError: { [weak self] _ in
                self?.output.onNext(LoginCoordinatorOutputEvent.signUpFailure)
            }).disposed(by: disposeBag)
    }
}
