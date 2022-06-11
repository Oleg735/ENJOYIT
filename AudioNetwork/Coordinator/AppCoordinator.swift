//
//  AppCoordinator.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

class AppCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController

    private var menuCoordinator: MenuCoordinator
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.barTintColor = UIColor(red: 45, green: 75, blue: 210)
        self.menuCoordinator = MenuCoordinator(navigationController: navigationController)
    }

    func start() {
        // check if user is signed in here and start appropriate flow
        menuCoordinator.start()
    }
}
