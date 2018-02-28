//
//  ToDoItem.swift
//  Todoey
//
//  Created by Yosef Shachnovsky on 27/02/2018.
//  Copyright © 2018 Yosef Shachnovsky. All rights reserved.
//

import Foundation

class ToDoItem: Encodable, Decodable{
    var content: String = ""
    var isDone: Bool = false
    
    init() {
    }
    
    convenience init(content:String, isDone: Bool) {
        self.init()
        
        self.content = content
        self.isDone = isDone
    }
    
    convenience init(content:String) {
        self.init()
        
        self.content = content

    }
    
}
