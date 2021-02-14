//
//  newCaseViewController.swift
//  DiarySimbirSoft
//
//  Created by Булат on 27.01.2021.
//

import UIKit
import FirebaseDatabase

typealias AddEventHandler = (EventModel) -> Void
class newCaseViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var titleText: UITextField!
    let ref = Database.database().reference()
    var handle: DatabaseHandle?
    var id = 1
    var onAddEventHandler: AddEventHandler?
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        datePicker.addTarget(self, action: #selector(dateDidChange), for: UIControl.Event.valueChanged)
        //read database
        ref.child("cases").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String : Any] else {
                return
            }
            print("Value: \(value)")
        })
    }
    
    @objc
    func dateDidChange() -> Int {
        let date = datePicker.date
        let hours = Calendar.current.component(.hour, from: date)
        let day = datePicker.calendar.component(.day, from: date)
        print("\(day)")
        return day
        //        let dateChange = NewCasePresenter()
        //        return dateChange.dateDidChange()
        // current date and time
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        //assin toolbar
        dateTextField.inputAccessoryView = toolbar
        //assign date picker to the text field
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.locale = Locale(identifier: "ru_RU")
    }
    
    @objc func doneButtonPressed() {
        //formatter
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE MM-dd-yyyy HH:mm"
        dateformatter.calendar = Calendar(identifier: .gregorian)
        dateformatter.locale = Locale(identifier: "ru_RU")
        dateTextField.text = dateformatter.string(from: datePicker.date)
        self.view.endEditing(true)
        //        let doneButton = NewCasePresenter()
        //        doneButton.doneButtonPressed()
        //        self.view.endEditing(true)
    }
    @IBAction func saveButton(_ sender: Any) {
        onAddEventHandler?(.init(id: 1, title: titleText.text ?? "название", specification: descriptionLabel.text, time: datePicker.date))
        if (titleText.text?.isEmpty)! || (descriptionLabel.text?.isEmpty)! {
            let alert = UIAlertController(title: "Внимание", message: "Поле не заполнено", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if (titleText.text?.count ?? 0 > 0) || (descriptionLabel.text.count > 0 ){
            self.navigationController?.popViewController(animated: true)
        }
        
        //self.navigationController?.popViewController(animated: true)
        //        let object: [String : Any] = [
        //            "id" : id ,"title" : titleText.text! , "deskription" : descriptionLabel.text ?? "description"
        //        ]
        //        let id = 1
        //        ref.child("cases_\(id)").setValue(object)
        //        let ref = Database.database().reference()
        //        ref.childByAutoId().setValue(["name" : "Tom", "role" : "admin"])
        //        ref.child("someid").observeSingleEvent(of: .value) { (snapshot) in
        //        let data = snapshot.value as? [String:Any]
        //
        //
        let dateAsTimestamp = datePicker.date.timeIntervalSince1970
        let object: [String : Any] = [
            "название" : titleText.text!, "описание" : descriptionLabel.text!, "время" : dateAsTimestamp
        ]
        ref.child("cases_\(Int.random(in: 0..<100))").childByAutoId().setValue(object)
        ref.observe(.value) { snapshot in
            let items = snapshot.value as? [String: Any]
            guard let items1 = items?["cases"] as? [String: [String: Any]] else { return }
            
            _ = items1.map { keyValue -> EventModel in
                let title = keyValue.value["название"] as! String
                let description = keyValue.value["описание"] as! String
                let time = Date(timeIntervalSince1970: keyValue.value["время"] as! Double )
                return EventModel(id: 0, title: title, specification: description, time: time)
            }
        }
    }
}
