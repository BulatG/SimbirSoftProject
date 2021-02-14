//
//  EventRealmModel.swift
//  DiarySimbirSoft
//
//  Created by Булат on 01.02.2021.
//

import Foundation
import RealmSwift

@objcMembers
class EventRealmModel: Object {
   dynamic var title = String()
   dynamic var specification = String()
   dynamic var time = Date()
}
