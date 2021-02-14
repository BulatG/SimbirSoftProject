//
//  newCasePresenter.swift
//  DiarySimbirSoft
//
//  Created by Булат on 05.02.2021.
//

import Foundation
import UIKit

class NewCasePresenter {

    
    let datePicker = UIDatePicker()
    
    func dateDidChange() -> Int {
//        let date = datePicker.date
//        let hours = Calendar.current.component(.hour, from: date)
//        let day = datePicker.calendar.component(.day, from: date)
//        print("\(day)")
//        return day
        return 1
    }
    
    func createDatePicker() {
        let dateText = newCaseViewController()
        let TextField = dateText.dateTextField
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        //assin toolbar
        TextField?.inputAccessoryView = toolbar
        //assign date picker to the text field
        datePicker.preferredDatePickerStyle = .wheels
        TextField?.inputView = datePicker
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.locale = Locale(identifier: "ru_RU")
        //datePicker mode
        //datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonPressed() {
        let dateText = newCaseViewController()
        let TextField = dateText.dateTextField
        //formatter
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE MM-dd-yyyy HH:mm"
        dateformatter.calendar = Calendar(identifier: .gregorian)
        dateformatter.locale = Locale(identifier: "ru_RU")
        TextField?.text = dateformatter.string(from: datePicker.date)
        
    }
}
