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
        let buttonCount = 5 // Update this value to the number of tabs you want
        
        let buttonSize = CGSize(width: 50, height: 50)
        let tabBarWidth = self.tabBar.bounds.width
        let middleButtonX = (tabBarWidth - buttonSize.width) / 27
        
        for index in 0..<buttonCount {
            let middleButton = UIButton(frame: CGRect(x: CGFloat(index) * tabBarWidth / CGFloat(buttonCount) + middleButtonX, y: -20, width: buttonSize.width, height: buttonSize.height))
            
            if index == buttonCount / 2 {
                let plusImage = UIImage(systemName: "plus")
                middleButton.setImage(plusImage, for: .normal)
                
                // Apply gradient background color
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = middleButton.bounds
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                
                if UserDefaults.standard.bool(forKey: UserDefaultsConstants.GradientColor1) {
                    gradientLayer.colors = [UIColor(hex: "91AFDD").cgColor, UIColor(hex: "BA91DD").cgColor]
                } else if UserDefaults.standard.bool(forKey: UserDefaultsConstants.GradientColor1He) {
                    gradientLayer.colors = [UIColor(hex: "C582FF").cgColor, UIColor(hex: "20D6CB").cgColor]
                } else {
                    gradientLayer.colors = [UIColor(hex: "F57A2C").cgColor, UIColor(hex: "F14452").cgColor]
                }
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
        if UserDefaults.standard.bool(forKey: UserDefaultsConstants.GradientColor1) {
            self.selectedIndex = sender.tag
            if let tabBarView = self.tabBar as? TabBarVC {
                if sender.tag == 2 {
                    tabBarView.setTabBarBackgroundColor(UIColor.clear)
                    tabBarView.setShapeLayerFillColor(UIColor.clear)
                } else {
                    tabBarView.setTabBarBackgroundColor(UIColor.white)
                    tabBarView.setShapeLayerFillColor(UIColor.white)
                }
            }
        } else if UserDefaults.standard.bool(forKey: UserDefaultsConstants.GradientColor1He) {
            self.selectedIndex = sender.tag
        } else {
            self.selectedIndex = sender.tag
            if let tabBarView = self.tabBar as? TabBarVC {
                if sender.tag == 2 {
                    tabBarView.setTabBarBackgroundColor(UIColor.clear)
                    tabBarView.setShapeLayerFillColor(UIColor.clear)
                } else {
                    tabBarView.setTabBarBackgroundColor(UIColor.white)
                    tabBarView.setShapeLayerFillColor(UIColor.white)
                }
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
