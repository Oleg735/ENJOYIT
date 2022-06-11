//
//  UITableView+Extension.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 07.06.2022.
//

import UIKit

extension UITableView {
    func cell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: "\(type)", for: indexPath) as? T else { return nil }
        return cell
    }

    func register<T: UITableViewCell>(cellType: T.Type) {
        let identifier = "\(cellType)"
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}

extension UITableView {
    func reloadDataWithAnimation(
        duration: TimeInterval = 0.15,
        options: AnimationOptions = .transitionCrossDissolve
    ) {
        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: { self.reloadData() }
        )
    }
}
