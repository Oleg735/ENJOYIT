//
//  MenuCoordinator.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

class MenuCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MenuViewController.instanceFromStoryboard()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushFind() {
        FindCoordinator(navigationController: navigationController).start()
    }
}
