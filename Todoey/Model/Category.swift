//
//  Category.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 04/03/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<ToDoItem>()
    
}
