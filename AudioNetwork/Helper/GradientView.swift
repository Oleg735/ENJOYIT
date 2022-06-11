//
//  GradientView.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

class GradientView: UIView {
    private var firstColor = UIColor(red: 52, green: 199, blue: 89)
    private var secondColor = UIColor(red: 0, green: 0, blue: 0)

    private var startPointX: CGFloat = 0
    private var startPointY: CGFloat = 0

    private var endPointX: CGFloat = 1
    private var endPointY: CGFloat = 1

    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint( x: startPointX, y: startPointY )
        gradientLayer.endPoint = CGPoint( x: endPointX, y: endPointY )
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
