//
//  LikedAddCoordinator.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 08.06.2022.
//

import UIKit

class LikedAddCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = LikedAddViewController.instanceFromStoryboard()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushSite(transfer: TasksCore) {
        SiteShowCoordinator(navigationController: navigationController).startData(dataTransfer: transfer)
    }
}
