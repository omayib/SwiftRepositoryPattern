//
//  Todo.swift
//  RepositoryPatterinInProject
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
class TodoCollection{
    var value:[Todo]
    
    init(todos:[Todo]) {
        self.value = todos
    }
    
    func getTodo(todo:Todo)-> Todo{
        if todo.id.isEmpty{
            return value.first(where: {$0.tempId == todo.tempId })!
        }else{
            return value.first(where: {$0.id == todo.id })!
        }
    }
}

class Todo{
    var tempId: String
    var id : String
    var title: String
    var isCompleted: Bool
    
    init(id:String? = "", title:String, isCompleted:Bool, tempId:String? = "") {
        self.id = id!
        self.title = title
        self.isCompleted = isCompleted
        self.tempId = tempId!
    }
}
