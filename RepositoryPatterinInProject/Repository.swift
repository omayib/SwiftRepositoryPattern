//
//  Repository.swift
//  RepositoryPatterinInProject
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
enum Response<T> {
    case succeed(T)
    case failed(message: String)
}
enum DataManagerResult<T> {
    case onNext(T)
    case onFinished(T)
    case onFailed(message: String)
}
protocol CachedData{
    var todosInCache:TodoCollection { get set }
}
protocol Repository{
    func getTodos(completion:@escaping(Response<[Todo]>)->())
    func getTodo(id:String, completion:@escaping(Response<Todo>)->())
    func addTodo(todo: Todo, completion:@escaping(Response<Todo>)->())
    func updateTodo(todo: Todo, completion:@escaping(Response<Todo>)->())
}
