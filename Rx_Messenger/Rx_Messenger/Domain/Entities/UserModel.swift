//
//  UserModel.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 24/5/24.
//

import Foundation

struct UserModel: Codable {
    var email: String
    var username: String
    var password: String
}

extension UserModel {
    static var currentUser: UserModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "currentUser") else { return nil }
            let user = try? JSONDecoder().decode(UserModel.self, from: data)
            return user
        }
        set {
            guard let user = newValue else {
                UserDefaults.standard.removeObject(forKey: "currentUser")
                return
            }
            let data = try? JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }
}
