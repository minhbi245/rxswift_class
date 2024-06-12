//
//  HomeCoordinator.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import UIKit

enum HomeRoute: Route {
    case home
}

class HomeCoordinator: NavigationCoordinator<AppRoute> {
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        super.init(initialRoute: .home)
    }
    
    override func prepareTransition(for route: Route) -> NavigationTransition {
        guard let route = route as? AppRoute else { return .none }
        switch route {
        case .home:
            let viewModel = HomeViewModel(userUseCase: userUseCase)
            let viewController = HomeViewController(viewModel: viewModel)
            return .push(viewController)
        default:
            return .none
        }
    }
    
}
