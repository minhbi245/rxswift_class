//
//  UserUseCase.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import Foundation
import RxSwift

protocol UserUseCase {
    func registerUser(user: UserModel) -> Completable
    func loginUser(email: String, password: String) -> Single<Bool>
    func getCurrentUser() -> Single<UserModel?>
}

class UserUseCaseImpl: UserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func registerUser(user: UserModel) -> Completable {
        return userRepository.saveUser(user: user)
    }
    
    func loginUser(email: String, password: String) -> Single<Bool> {
        return userRepository.getUser().map { user in
            return user?.email == email && user?.password == password
        }
    }
    
    func getCurrentUser() -> Single<UserModel?> {
        return userRepository.getUser()
    }
}
