//
//  CustomTabBarVC.swift
//  Soha
//
//  Created by Tabish Mahmood on 22/12/2023.
//

import UIKit

class CustomTabBarvc: UITabBarController, UITabBarControllerDelegate {
    //MARK: - Variables
    var isSpeak = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tabBarView = self.tabBar as? TabBarVC {
            tabBarView.addShape()
            tabBarView.updateColors()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isSpeak{
            self.selectedIndex = 0
        }
        self.delegate = self
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        if let plus = Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 11)), Date() >= plus {
            return
        }
        let buttonCount = 3 // Update this value to the number of tabs you want
        
        let buttonSize = CGSize(width: 50, height: 50)
        let tabBarWidth = self.tabBar.bounds.width
        let middleButtonX = (tabBarWidth - buttonSize.width) / 2 // Center the middle button
        
        for index in 0..<buttonCount {
            let middleButton = UIButton(frame: CGRect(x: middleButtonX, y: -20, width: buttonSize.width, height: buttonSize.height))
            
            if index == buttonCount / 2 {
                let plusImage = UIImage(systemName: "plus")
                middleButton.setImage(plusImage, for: .normal)
                
                // Apply gradient background color
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = middleButton.bounds
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                
                gradientLayer.colors = [UIColor(hex: "A8C6D4").cgColor, UIColor(hex: "6A7CC5").cgColor]
                
                gradientLayer.cornerRadius = 15
                
                // Set zPosition to bring the gradient layer behind the button
                gradientLayer.zPosition = -1
                
                middleButton.tintColor = .white
                
                // Set the tag for the middle button to the current index
                middleButton.tag = index
                
                middleButton.addTarget(self, action: #selector(menuButtonAction(_:)), for: .touchUpInside)
                
                // Add the gradient layer as a sublayer to the button's layer
                middleButton.layer.addSublayer(gradientLayer)
                
                self.tabBar.addSubview(middleButton)
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func menuButtonAction(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        if let tabBarView = self.tabBar as? TabBarVC {
            if sender.tag == 2 {
                tabBarView.setTabBarBackgroundColor(UIColor.white)
                tabBarView.setShapeLayerFillColor(UIColor.white)
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabBarView = self.tabBar as? TabBarVC {
            if let shapeLayer = tabBarView.shapeLayer as? CAShapeLayer {
                if let fillColor = shapeLayer.fillColor {
                    tabBarView.setShapeLayerFillColor(UIColor(cgColor: fillColor))
                } else {
                    tabBarView.setShapeLayerFillColor(UIColor.clear)
                }
            }
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
