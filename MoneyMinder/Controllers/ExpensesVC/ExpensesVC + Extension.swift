//
//  ExpensesVC + Extension.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 19/03/2024.
//

import Foundation
import UIKit

extension ExpensesVC {
    func setUI() {
        for view in backgroundViews {
            view.layer.cornerRadius = 14
            view.layer.masksToBounds = true
        }
        saveBtn.layer.cornerRadius = 14
        imageBackView.layer.cornerRadius = 14
        imageBackView.layer.borderColor = UIColor.black.cgColor
        imageBackView.layer.borderWidth = 1
        imageBackView.layer.masksToBounds = true
        addImg.image = nil
        dateTF.text = ""
        categoryTF.text = ""
        descriptionTF.text = ""
        totalTF.text = ""
        showDatePicker()
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTF.inputAccessoryView = toolbar
        dateTF.inputView = datePicker
        dateTF.tintColor = .clear
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        datePicker.minimumDate = Date()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
