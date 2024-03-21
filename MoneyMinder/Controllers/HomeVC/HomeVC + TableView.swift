//
//  HomeVC + TableView.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 19/03/2024.
//

import UIKit

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        let currentExpense = expensesArray[indexPath.row]
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Check if indexPath.row is within bounds of expensesArray
            guard indexPath.row < expensesArray.count else {
                print("Index out of range")
                return
            }
            
            showYesNoAlert(title: "Alert", message: "Are you sure you want to delete this one.?") { [weak self] in
                guard let self = self else { return }
                
                self.expensesArray.remove(at: indexPath.row)
                self.updateExpensesArray()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.updateTotalAmount()
            }
        }
    }
    
    func showYesNoAlert (title: String?, message: String, completion:@escaping () -> Void) {
        let customAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { _ in
            completion()
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { _ in
        }
        customAlert.view.tintColor = #colorLiteral(red: 0.09803921569, green: 0.6352941176, blue: 1, alpha: 1)
        
        customAlert.addAction(noAction)
        customAlert.addAction(yesAction)
        self.present(customAlert, animated: true, completion: nil)
    }
}
