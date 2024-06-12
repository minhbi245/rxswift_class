//
//  LoginViewModel.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    private let userUseCase: UserUseCase
    let disposeBag = DisposeBag()

    // Sign Up properties
    let name = BehaviorRelay<String>(value: "")
    let signUpEmail = BehaviorRelay<String>(value: "")
    let signUpPassword = BehaviorRelay<String>(value: "")
    let registerSuccess = PublishSubject<Bool>()

    // Sign In properties
    let signInEmail = BehaviorRelay<String>(value: "")
    let signInPassword = BehaviorRelay<String>(value: "")
    let loginSuccess = PublishSubject<Bool>()
    let loginButtonTapped = PublishRelay<Void>()
    let signUpButtonTapped = PublishRelay<Void>()

    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        setupBindings()
    }

    private func setupBindings() {
        signUpButtonTapped
            .withLatestFrom(Observable.combineLatest(name, signUpEmail, signUpPassword))
            .flatMapLatest { [unowned self] name, email, password in
                let user = UserModel(email: email, username: name, password: password)
                return self.userUseCase.registerUser(user: user)
                    .andThen(Observable.just(true))
                    .catchAndReturn(false)
            }
            .bind(to: registerSuccess)
            .disposed(by: disposeBag)

        loginButtonTapped
            .withLatestFrom(Observable.combineLatest(signInEmail, signInPassword))
            .flatMapLatest { [unowned self] email, password in
                self.userUseCase.loginUser(email: email, password: password)
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let success):
                    self?.loginSuccess.onNext(success)
                case .error(_):
                    self?.loginSuccess.onNext(false)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
