//
//  UserRepository.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    func saveUser(user: UserModel) -> Completable
    func getUser() -> Single<UserModel?>
}

class UserRepositoryImpl: UserRepository {
    func saveUser(user: UserModel) -> Completable {
        return Completable.create { completable in
            let data = try? JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: "currentUser")
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func getUser() -> Single<UserModel?> {
        return Single.create { single in
            guard let data = UserDefaults.standard.data(forKey: "currentUser") else {
                single(.success(nil))
                return Disposables.create()
            }
            let user = try? JSONDecoder().decode(UserModel.self, from: data)
            single(.success(user))
            return Disposables.create()
        }
    }
}
