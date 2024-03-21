//
//  SplashVC.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 18/03/2024.
//

import UIKit

class SplashVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var moneyMinderImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moneyMinderImg.layer.cornerRadius = 95
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomTabBarvc") as? CustomTabBarvc
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
