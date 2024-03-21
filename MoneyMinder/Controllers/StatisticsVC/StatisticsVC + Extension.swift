//
//  StatisticsVC + Extension.swift
//  MoneyMinder
//
//  Created by Tabish Mahmood on 20/03/2024.
//

import Foundation
import UIKit

extension StatisticsVC {
    func setColorsOnTap(todayBackColor: UIColor, WeeklyBackColor: UIColor, MonthBackColor: UIColor, todayTextColor: UIColor, weeklyTextColor: UIColor, monthTextColor: UIColor) {
        todayBtn.backgroundColor = todayBackColor
        weeklyBtn.backgroundColor = WeeklyBackColor
        monthlyBtn.backgroundColor = MonthBackColor
        todayBtn.tintColor = todayTextColor
        weeklyBtn.tintColor = weeklyTextColor
        monthlyBtn.tintColor = monthTextColor
    }
    
    func setColors(backColor: UIColor, textColor: UIColor, corners: CGFloat) {
        todayBtn.layer.cornerRadius = corners
        weeklyBtn.layer.cornerRadius = corners
        monthlyBtn.layer.cornerRadius = corners
        weeklyBtn.backgroundColor = backColor
        monthlyBtn.backgroundColor = backColor
        weeklyBtn.tintColor = textColor
        monthlyBtn.tintColor = textColor
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
}
