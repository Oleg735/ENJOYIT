//
//  SiteShowCoordinator.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

class SiteShowCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SiteShowViewController.instanceFromStoryboard()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func start(dataTransfer: Track) {
        let vc = SiteShowViewController.instanceFromStoryboard()
        vc.coordinator = self
        vc.transfer = dataTransfer
        navigationController.pushViewController(vc, animated: true)
    }
    
    func startData(dataTransfer: TasksCore) {
        let vc = SiteShowViewController.instanceFromStoryboard()
        vc.coordinator = self
        vc.transferFromCore = dataTransfer
        navigationController.pushViewController(vc, animated: true)
    }
}
