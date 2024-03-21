//
//  StatisticsVC + TableView.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 20/03/2024.
//

import Foundation
import UIKit

extension StatisticsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredExpenses = filterExpenses(for: selectedPeriod)
        return filteredExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        if var expensesArray = UserDefaults.standard.array(forKey: "expensesArray") as? [[String: Any]] {
            expensesArray.sort { (expense1, expense2) -> Bool in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                
                guard let date1String = expense1["date"] as? String,
                      let date2String = expense2["date"] as? String,
                      let date1 = formatter.date(from: date1String),
                      let date2 = formatter.date(from: date2String) else {
                    return false
                }
                
                // Checking if the dates are today
                let isToday1 = Calendar.current.isDateInToday(date1)
                let isToday2 = Calendar.current.isDateInToday(date2)
                
                // Comparing the dates
                if isToday1 && isToday2 {
                    // Both dates are today, maintain original order
                    return true
                } else if isToday1 {
                    // First date is today, prioritize it
                    return true
                } else if isToday2 {
                    // Second date is today, prioritize it
                    return false
                } else {
                    // Neither date is today, compare dates normally
                    return date1 > date2
                }
            }
            
            if indexPath.row < expensesArray.count {
                let filteredExpenses = filterExpenses(for: selectedPeriod)
                
                let currentExpense = filteredExpenses[indexPath.row]
                let currentDate = currentExpense["date"] as? String ?? ""
                
                let isDifferentDate = indexPath.row == 0 || currentDate != expensesArray[indexPath.row - 1]["date"] as? String ?? ""
                
                let isToday = getCurrentDate()
                
                if isDifferentDate {
                    cell.dateLbl.isHidden = false
                    cell.dateLbl.text = currentDate == isToday ? "Today" : currentDate
                } else {
                    cell.dateLbl.isHidden = true
                }
                
                if let imageData = currentExpense["image"] as? Data {
                    cell.expendImg.image = UIImage(data: imageData)
                } else {
                    cell.expendImg.image = UIImage(systemName: "stroller")
                }
                cell.titleLbl.text = currentExpense["category"] as? String ?? ""
                cell.descriptionLbl.text = currentExpense["description"] as? String ?? ""
                cell.priceLbl.text = "$ \(currentExpense["total"] as? String ?? "")"
            }
        }
        
        return cell
    }
}
