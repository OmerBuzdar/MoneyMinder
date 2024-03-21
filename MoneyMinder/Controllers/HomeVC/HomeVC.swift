//
//  HomeVC.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 19/03/2024.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStackView: UIStackView!
    @IBOutlet var cardImg: [UIImageView]!
    
    var expensesArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        for imageView in cardImg {
            imageView.layer.cornerRadius = 16
        }
        tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let storedExpenses = UserDefaults.standard.array(forKey: "expensesArray") as? [[String: Any]] {
            expensesArray = storedExpenses
        }
        updateTotalAmount()
        tableView.reloadData()
    }
    
    func updateExpensesArray() {
        UserDefaults.standard.set(expensesArray, forKey: "expensesArray")
    }
    
    func updateTotalAmount() {
        var totalAmount: Float = 0
        
        if let expensesArray = UserDefaults.standard.array(forKey: "expensesArray") as? [[String: Any]] {
            for expense in expensesArray {
                if let totalString = expense["total"] as? String,
                   let total = Float(totalString) {
                    totalAmount += total
                }
            }
            tableView.isHidden = expensesArray.isEmpty
            emptyStackView.isHidden = !expensesArray.isEmpty
        }
        
        let animationDuration: TimeInterval = 1
        let totalSteps = 100
        let stepAmount = totalAmount / Float(totalSteps)
        
        var currentStep: Float = 0
        
        Timer.scheduledTimer(withTimeInterval: animationDuration / Double(totalSteps), repeats: true) { timer in
            currentStep += stepAmount
            self.amountLbl.text = String(format: "$ %.2f", currentStep)
            
            if currentStep >= totalAmount {
                timer.invalidate()
                self.amountLbl.text = String(format: "$ %.2f", totalAmount)
            }
        }
    }

    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
}
