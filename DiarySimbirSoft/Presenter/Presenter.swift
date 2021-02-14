//
//  Presenter.swift
//  DiarySimbirSoft
//
//  Created by Булат on 04.02.2021.
//

import Foundation
import RealmSwift
import EventKit
import RealmSwift

class Presenter {
    
    let dbManager: DBManager = DBManagerImpl()
    var post: [Int:EventModel] = [:]
        
    func obtainEvents() {
        dbManager.obtainEvents(date: Date()).forEach {
            let hour = Calendar.current.component(.hour, from: $0.time)
            post[hour] = $0
        }
    }
    func removeAllfromCell(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY at h:mm a"
        let string = formatter.string(from: date)
        print("\(string)")
        let day = Calendar.current.component(.day, from: date)
        print("\(day)")
        post.removeAll()
        }
    
    func obtainDayEvent(date: Date){
        let event = dbManager.obtainEvents(date: date).forEach {
        let hour = Calendar.current.component(.hour, from: $0.time)
        post[hour] = $0
        }
        //reload data
    }
}
