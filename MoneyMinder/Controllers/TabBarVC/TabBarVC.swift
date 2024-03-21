//
//  TabBarVC.swift
//  Soha
//
//  Created by Tabish Mahmood on 22/12/2023.
//

import Foundation
import UIKit

class TabBarVC: UITabBar {
    
    var shapeLayer: CALayer?
    private var shapeLayer2: CAShapeLayer?
    
    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = createPath()
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addShape()
        updateColors()
    }
    
    func updateColors() {
        if let shapeLayer = self.shapeLayer {
            if let shapeLayer = shapeLayer as? CAShapeLayer {
                self.unselectedItemTintColor = .black
                self.tintColor = .darkGray
                shapeLayer.strokeColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    func createPath() -> CGPath {
        
        let height: CGFloat = 55
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 1.2), y: 0)) // the beginning of the trough
        
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 40), y: 0), controlPoint2: CGPoint(x: centerWidth - 50, y: height))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height * 1.2 ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 40, y: 57), controlPoint2: CGPoint(x: (centerWidth + 48), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    func setTabBarBackgroundColor(_ color: UIColor) {
        // Change the background color of the tab bar
        self.layer.backgroundColor = color.cgColor
    }
    
    func setShapeLayerFillColor(_ color: UIColor) {
        self.shapeLayer2?.fillColor = color.cgColor
    }
}
