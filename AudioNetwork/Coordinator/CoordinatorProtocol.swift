//
//  CoordinatorProtocol.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var parentCoordinator: CoordinatorProtocol? { get set }
    var children: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func popBack()
}

extension CoordinatorProtocol {
    func popBack() {
        navigationController.popViewController(animated: true)
    }
}
