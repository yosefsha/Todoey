//
//  ToDoItem.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 04/03/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var content: String = ""
    @objc dynamic var isDone: Bool = false
    
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
