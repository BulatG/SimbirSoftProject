//
//  ViewController.swift
//  DiarySimbirSoft
//
//  Created by Булат on 21.01.2021.
//

import UIKit
import FSCalendar
import EventKit
import RealmSwift
import FirebaseDatabase
import Network

struct A: Codable {
    let date: Date
}
class ViewController: UIViewController, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var calendar: FSCalendar!
    let dbManager: DBManager = DBManagerImpl()
    let ref = Database.database().reference()
    var post: [Int:EventModel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //        let a = A(date: Date())
        //        let data = try! JSONEncoder().encode(a)
        //        print(String(data: data, encoding: .utf8))
        
        ref.observe(.value) { snapshot in
            let items = snapshot.value as? [String: Any]
            guard let items1 = items?["cases"] as? [String: [String: Any]] else { return  }
            
            let models = items1.map { keyValue -> EventModel in
                let title = keyValue.value["название"] as! String
                let description = keyValue.value["описание"] as! String
                let time = Date(timeIntervalSince1970: keyValue.value["время"] as? Double ?? 12345678 )
                DispatchQueue.main.async {
                    let _: () = self.dbManager.save(event: EventModel(id: 0, title: title, specification: description, time: time))
                }
                return EventModel(id: 0, title: title, specification: description, time: time)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        
        
        connectedRef.observe(.value, with: { snapshot in
            
            if snapshot.value as? Bool ?? true {
                print("Connected")
                //counter = 1
            } else {
                let alert = UIAlertController(title: "Внмание", message: "Нет сети. Дело будет добавлено в локальную базу", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Not connected")
            }
        })
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY at h:mm a"
        let string = formatter.string(from: date)
        print("\(string)")
        let day = Calendar.current.component(.day, from: date)
        print("\(day)")
        post.removeAll()
        let event = dbManager.obtainEvents(date: date).forEach {
            let hour = Calendar.current.component(.hour, from: $0.time)
            post[hour] = $0
        }
        print(post)
        self.tableView.reloadData()
        //        let removeDataFromCell = Presenter()
        //        removeDataFromCell.removeAllfromCell(date: date)
        //        let obtainDayEvent = Presenter()
        //        obtainDayEvent.obtainDayEvent(date: date)
        //        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CustomTableViewCell
        if let model = post[indexPath.row] {
            cell.configure(with: .init(title: model.title, time: indexPath.row))
        } else {
            cell.configure(with: .init(title: nil, time: indexPath.row))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detailIdentifier", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {return}
        
        switch segueIdentifier {
        case SegueIdentifier.post.rawValue:
            if let index = sender as? Int {
                let postModel = post[index]
                let destController = segue.destination as! CasedescripionViewController
                destController.post = postModel
                destController.onEditPostHandler = { [weak self] model in
                    guard let self = self else { return }
                    let hour = Calendar.current.component(.hour, from: model.time)
                    self.post[hour] = model
                    self.tableView.reloadData()
                }
            }
        case SegueIdentifier.createpost.rawValue:
            let destController = segue.destination as! newCaseViewController
            destController.onAddEventHandler = { [weak self] model in
                guard let self = self else { return }
                let postFormat = self.dbManager.save(event: model)
                let hour = Calendar.current.component(.hour, from: model.time)
                self.post[hour] = model
                self.tableView.reloadData()
            }
        default:
            return
        }
    }
}

private extension ViewController {
    enum SegueIdentifier: String {
        case post = "detailIdentifier"
        case createpost = "addpostidentifier"
    }
}
