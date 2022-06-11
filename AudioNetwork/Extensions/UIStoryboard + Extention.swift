//
//  UIStoryboard + Extention.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case menu
        case find
        case siteShow
        case liked
        var fileName: String {
            return rawValue.capitalizingFirstLetter()
        }
    }
}
