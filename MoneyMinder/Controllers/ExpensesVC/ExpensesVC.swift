//
//  ExpensesVC.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 19/03/2024.
//

import UIKit

class ExpensesVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet var backgroundViews: [UIView]!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var totalTF: UITextField!
    @IBOutlet weak var addImg: UIImageView!
    @IBOutlet weak var plusIconImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var imageBackView: UIView!
    
    //MARK: - Variables
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    //MARK: - Actions
    @IBAction func addImageBtnClicked(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [self] image in
            plusIconImg.isHidden = true
            addImg.image = image
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if dateTF.text == "" {
            showToast(message: "Please select a date")
        } else if categoryTF.text == "" {
            showToast(message: "Please enter a category")
        } else if descriptionTF.text == "" {
            showToast(message: "Please enter description")
        } else if totalTF.text == "" {
            showToast(message: "Please enter total price")
        } else {
            var expenseData = [String: Any]()
            
            expenseData["id"] = UUID().uuidString // Generate a unique ID for the expense
            expenseData["date"] = dateTF.text
            expenseData["category"] = categoryTF.text
            expenseData["description"] = descriptionTF.text
            expenseData["total"] = totalTF.text
            if let imageData = addImg.image?.pngData() {
                expenseData["image"] = imageData
            }
            
            var expensesArray = UserDefaults.standard.array(forKey: "expensesArray") as? [[String: Any]] ?? []
            
            expensesArray.append(expenseData)
            
            UserDefaults.standard.set(expensesArray, forKey: "expensesArray")
            if let tabBarVC = self.tabBarController {
                tabBarVC.selectedIndex = 0
            }
        }
    }
}

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor(named: "3F51B5")
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
