//
//  DBManager.swift
//  DiarySimbirSoft
//
//  Created by Булат on 01.02.2021.
//

import Foundation
import RealmSwift

protocol DBManager {
    func save(event: EventModel)
    func obtainEvents(date: Date) -> [EventModel] 
}
class DBManagerImpl: DBManager {
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)

    func save(event: EventModel) {
        try! mainRealm.write {
            mainRealm.add(event)
        }
    }
    func obtainEvents(date: Date) -> [EventModel] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let startNextDay = Calendar.current.startOfDay(for: nextDay)
        let events = mainRealm.objects(EventModel.self).filter { $0.time >= startOfDay && $0.time < startNextDay }
        return Array(events)
    }
}
