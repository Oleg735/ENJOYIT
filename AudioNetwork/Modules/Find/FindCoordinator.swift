//
//  FindCoordinator.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

class FindCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = FindViewController.instanceFromStoryboard()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushSite(transfer: Track) {
        SiteShowCoordinator(navigationController: navigationController).start(dataTransfer: transfer)
    }
    
    func pushSLiked() {
        LikedAddCoordinator(navigationController: navigationController).start()
    }
}
