//
//  Category.swift
//  Todoey
//
//  Created by Byungsuk Choi on 11/22/19.
//  Copyright © 2019 Byungsuk Choi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
