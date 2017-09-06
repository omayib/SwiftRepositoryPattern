//
//  DataManager.swift
//  RepositoryPatterinInProject
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
protocol DataManagerDelegate{
    func dataDidLoad(todos: TodoCollection)
    func dataDidChanged()
    func dataTransactionSucceed()
    func dataTransactionFailure(errorMessage: String)
}
class DataManager{
    var cacheRepository: Repository&CachedData
    let cloudRepository: Repository
    var delegate: DataManagerDelegate?
    
    init() {
        self.cacheRepository = CacheRepository()
        self.cloudRepository = RemoteRepository()
    }
    func refreshTodos()->[Todo]{
        
        return cacheRepository.todosInCache.value
    }
    func getTodos(){
        
        if cacheRepository.todosInCache.value.isEmpty {
            print("requesting to server")
            cloudRepository.getTodos(completion: { result in
                switch result{
                case .failed(message: _):
                    self.delegate?.dataTransactionFailure(errorMessage: "salah")
                    break;
                case .succeed(let todos):
                    self.cacheRepository.todosInCache.value = todos
                    self.delegate?.dataDidLoad(todos: self.cacheRepository.todosInCache)
                    break;
                }
            })
        }else{
            print("take from cache")
            self.delegate?.dataDidLoad(todos: self.cacheRepository.todosInCache)
        }
    }
    
    func addTodo(todoCandidate:Todo){
        cacheRepository.addTodo(todo: todoCandidate) { rs in
            switch rs{
            case .failed(message: _):
                break;
            case .succeed( _):
                self.delegate?.dataDidChanged()
                break;
            }
        }
        cloudRepository.addTodo(todo: todoCandidate) { rs in
            switch rs{
            case .failed(message: _):
                self.delegate?.dataTransactionFailure(errorMessage: "salah")
                break;
            case .succeed(let item):
                //update the temporary data in the cache memory
                if let c = self.cacheRepository.todosInCache.value.first(where: {$0.tempId == item.tempId}){
                    c.id = item.id
                }
                self.delegate?.dataTransactionSucceed()
                break;
            }
        }
    }
    
    
    func updateTodo(todo:Todo){
        //hold the old value
        let candidate = todo
        let selected = cacheRepository.todosInCache.getTodo(todo: candidate)
        let oldTodo = Todo(id: selected.id, title: selected.title, isCompleted: selected.isCompleted, tempId: selected.tempId)

        cacheRepository.updateTodo(todo: candidate) { rs in
            switch rs{
            case .failed(message: _):
                self.delegate?.dataTransactionFailure(errorMessage: "salah")
                break;
            case .succeed( _):
                self.delegate?.dataDidChanged()
                break;
            }
        }
        cloudRepository.updateTodo(todo: candidate) { rs in
            switch rs{
            case .failed(message: _):
                self.cacheRepository.updateTodo(todo: oldTodo, completion: {_ in})
                self.delegate?.dataTransactionFailure(errorMessage: "salah")
                break;
            case .succeed( _):
                self.delegate?.dataTransactionSucceed()
                break;
            }
        }
    }
}
