//
//  CacheRepository.swift
//  RepositoryPatterinInProject
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation

class CacheRepository: Repository, CachedData{
    
    var todosInCache:TodoCollection
    
    init() {
        self.todosInCache = TodoCollection(todos: [])
    }
    
    
    func getTodos(completion: @escaping(Response<[Todo]>) -> ()) {
        completion(Response.succeed(self.todosInCache.value))
    }
    
    func getTodo(id: String, completion:@escaping (Response<Todo>) -> ()) {
        
        if let item = self.todosInCache.value.first(where: {$0.id == id}) {
            completion(Response.succeed(item))
        }else if let itemTemp = self.todosInCache.value.first(where: {$0.tempId == id}) {
            completion(Response.succeed(itemTemp))
        }else{
            completion(Response.failed(message: "item not found"))
        }
        
    }
 
    func updateTodo(todo: Todo, completion:@escaping (Response<Todo>) -> ()) {
        if let item = self.todosInCache.value.first(where: {$0.tempId == todo.tempId}) {
            item.id = todo.id
            item.isCompleted = todo.isCompleted
            item.title = todo.title
            completion(Response.succeed(item))
        }else if let item = self.todosInCache.value.first(where: {$0.id == todo.id}) {
            item.isCompleted = todo.isCompleted
            item.title = todo.title
            completion(Response.succeed(item))
        }else{
            completion(Response.failed(message: "item not found"))
        }
    }
    
    func addTodo(todo: Todo, completion:@escaping (Response<Todo>) -> ()) {
        self.todosInCache.value.append(todo)
        completion(Response.succeed(todo))
    }
}
