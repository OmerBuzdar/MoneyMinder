//
//  StatisticsVC.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 20/03/2024.
//

import UIKit

class StatisticsVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet var digramImg: [UIImageView]!
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var noDataFoundStackView: UIStackView!
    
    var selectedPeriod: FilterPeriod = .today
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        for imageView in digramImg {
            imageView.layer.cornerRadius = 16
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setColors(backColor: .grayColorForTF, textColor: UIColor(named: "DarkColor") ?? .blue, corners: 12)
        todayBtn.backgroundColor = UIColor(named: "DarkColor")
        todayBtn.tintColor = .white
        let todayExpenses = filterExpenses(for: .today)
        updateUI(with: todayExpenses)
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func todayBtnClicked(_ sender: Any) {
        selectedPeriod = .today
        setColorsOnTap(todayBackColor: UIColor(named: "DarkColor") ?? .blue, WeeklyBackColor: .grayColorForTF, MonthBackColor: .grayColorForTF, todayTextColor: .white , weeklyTextColor: UIColor(named: "DarkColor") ?? .blue, monthTextColor: UIColor(named: "DarkColor") ?? .blue)
        let todayExpenses = filterExpenses(for: .today)
        updateUI(with: todayExpenses)
    }
    
    @IBAction func weeklyBtnClicked(_ sender: Any) {
        selectedPeriod = .weekly
        setColorsOnTap(todayBackColor: .grayColorForTF, WeeklyBackColor: UIColor(named: "DarkColor") ?? .blue, MonthBackColor: .grayColorForTF, todayTextColor: UIColor(named: "DarkColor") ?? .blue, weeklyTextColor: .white, monthTextColor: UIColor(named: "DarkColor") ?? .blue)
        let todayExpenses = filterExpenses(for: .weekly)
        updateUI(with: todayExpenses)
    }
    
    @IBAction func monthlyBtnClicked(_ sender: Any) {
        selectedPeriod = .monthly
        setColorsOnTap(todayBackColor: .grayColorForTF, WeeklyBackColor: .grayColorForTF, MonthBackColor: UIColor(named: "DarkColor") ?? .blue, todayTextColor: UIColor(named: "DarkColor") ?? .blue, weeklyTextColor: UIColor(named: "DarkColor") ?? .blue, monthTextColor: .white)
        let todayExpenses = filterExpenses(for: .monthly)
        updateUI(with: todayExpenses)
    }
    
    func filterExpenses(for period: FilterPeriod) -> [[String: Any]] {
        guard let expensesArray = UserDefaults.standard.array(forKey: "expensesArray") as? [[String: Any]] else {
            return []
        }
        
        let filteredExpenses: [[String: Any]]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        switch period {
        case .today:
            let todayDateString = dateFormatter.string(from: Date())
            filteredExpenses = expensesArray.filter { expense in
                guard let dateString = expense["date"] as? String else {
                    return false
                }
                return dateString == todayDateString
            }
        case .weekly:
            let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()
            let startDateString = dateFormatter.string(from: startDate)
            filteredExpenses = expensesArray.filter { expense in
                guard let dateString = expense["date"] as? String else {
                    return false
                }
                return dateString >= startDateString
            }
        case .monthly:
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
            let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? Date()
            let startOfMonthString = dateFormatter.string(from: startOfMonth)
            let endOfMonthString = dateFormatter.string(from: endOfMonth)
            filteredExpenses = expensesArray.filter { expense in
                guard let dateString = expense["date"] as? String else {
                    return false
                }
                return dateString >= startOfMonthString && dateString <= endOfMonthString
            }
        }
        
        return filteredExpenses
    }
    
    
    private func updateUI(with expenses: [[String: Any]]) {
        let totalAmount = expenses.reduce(0.0) { total, expense in
            if let totalString = expense["total"] as? String,
               let expenseTotal = Float(totalString) {
                return total + Double(expenseTotal)
            }
            return total
        }
        
        tableView.reloadData()
        tableView.isHidden = expenses.isEmpty
        noDataFoundStackView.isHidden = !expenses.isEmpty
        
        let animationDuration: TimeInterval = 1
        let totalSteps = 100
        let stepAmount = totalAmount / Double(totalSteps)
        var currentStep: Double = 0
        
        Timer.scheduledTimer(withTimeInterval: animationDuration / Double(totalSteps), repeats: true) { timer in
            currentStep += stepAmount
            self.amountLbl.text = String(format: "$ %.2f", currentStep)
            
            if currentStep >= totalAmount {
                timer.invalidate()
                self.amountLbl.text = String(format: "$ %.2f", totalAmount)
            }
        }
    }
}

extension DateFormatter {
    static func date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: string)
    }
}

enum FilterPeriod {
    case today
    case weekly
    case monthly
}
