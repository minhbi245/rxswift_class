//
//  HomeViewModel.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import RxSwift
import RxCocoa

class HomeViewModel {
    private let userUseCase: UserUseCase
    let disposeBag = DisposeBag()
    
    let user = BehaviorRelay<UserModel?>(value: nil)
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func fetchUser() {
        userUseCase.getCurrentUser()
            .subscribe(onSuccess: { user in
                self.user.accept(user)
            }).disposed(by: disposeBag)
    }
}
