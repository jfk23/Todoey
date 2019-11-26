//
//  Item.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/22/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //@objc dynamic var dateCreated: Double = 0.0
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
