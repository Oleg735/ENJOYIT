//
//  StoryboardInstantiable.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

protocol StoryboardInstantiable: AnyObject {
    associatedtype MyType
    static var storyboardFileName: UIStoryboard.Storyboard { get }
    static var storyboardIdentifier: String { get }
    static func instanceFromStoryboard(_ bundle: Bundle?) -> MyType
}

extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instanceFromStoryboard(_ bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: storyboardFileName.fileName, bundle: nil)
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: storyboardIdentifier)
        } else {
            return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        }
    }
}
