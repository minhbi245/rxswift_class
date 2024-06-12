//
//  AppCoordinator.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import UIKit

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    private let userUseCase: UserUseCase
    
    init(navigationController: UINavigationController, userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        super.init(initialRoute: .login)
        self.navigationController = navigationController
    }
    
    override func prepareTransition(for route: Route) -> NavigationTransition {
        guard let route = route as? AppRoute else { return .none }
        switch route {
        case .login:
            let loginCoordinator = LoginCoordinator(userUseCase: userUseCase)
            loginCoordinator.navigationController = navigationController
            return .embed(loginCoordinator)
        default:
            return .none
        }
    }
}
