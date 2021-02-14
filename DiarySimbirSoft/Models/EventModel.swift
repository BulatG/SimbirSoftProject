//
//  EventModel.swift
//  DiarySimbirSoft
//
//  Created by Булат on 31.01.2021.
//

import Foundation
import RealmSwift

@objcMembers
class EventModel: Object {
    override init(){
        super.init()
    }
    internal init(id:Int, title: String, specification: String?, time: Date) {
        self.id = id
        self.title = title
        self.specification = specification
        self.time = time
    }
    
    dynamic var id = Int()
    dynamic var title = String()
    dynamic var specification: String? = ""
    dynamic var time: Date = Date()
}
