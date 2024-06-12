//
//  NavigationCoordinator.swift
//  Rx_Messenger
//
//  Created by khanhnvm-macbook on 4/6/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol CoordinatorInput {
    var input: ReplaySubject<LoginCoordinatorInputEvent> { get }
}

protocol CoordinatorOutput {
    var output: ReplaySubject<LoginCoordinatorOutputEvent> { get }
}

public protocol Route {}

enum AppRoute: Route {
    case login
    case home
}

enum LoginCoordinatorInputEvent {
    case loginRequested(email: String, password: String)
    case signUpRequested(name: String, email: String, password: String)
}

enum LoginCoordinatorOutputEvent {
    case loginSuccess
    case loginFailure
    case signUpSuccess
    case signUpFailure
}

protocol Coordinator: AnyObject, CoordinatorOutput, CoordinatorInput {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }

    func start()
    func navigate(to route: Route)
    func prepareTransition(for route: Route) -> NavigationTransition
    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator)
}

enum NavigationTransition {
    case push(UIViewController)
    case embed(Coordinator)
    case none
}

class NavigationCoordinator<R: Route>: Coordinator {
    var input: ReplaySubject<LoginCoordinatorInputEvent> = ReplaySubject.create(bufferSize: 1)
    var output: ReplaySubject<LoginCoordinatorOutputEvent> = ReplaySubject.create(bufferSize: 1)
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let initialRoute: R

    init(initialRoute: R) {
        self.initialRoute = initialRoute
    }

    func start() {
        navigate(to: initialRoute)
    }

    func navigate(to route: Route) {
        guard let route = route as? R else { return }
        let transition = prepareTransition(for: route)
        handleTransition(transition)
    }

    func prepareTransition(for route: Route) -> NavigationTransition {
        fatalError("prepareTransition(for:) has not been implemented")
    }

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    private func handleTransition(_ transition: NavigationTransition) {
        switch transition {
        case .push(let viewController):
            navigationController?.pushViewController(viewController, animated: true)
        case .embed(let coordinator):
            coordinator.parentCoordinator = self
            coordinator.navigationController = navigationController
            coordinator.start()
            addChild(coordinator)
        case .none:
            break
        }
    }
}
