//
//  RemoteRepository.swift
//  RepositoryPatterinInProject
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//
import Alamofire
import Foundation
import SwiftyJSON

class RemoteRepository: Repository{
    var url:String = "http://192.168.0.100:3000/todos"
    private var todos:[Todo] = []
    
    func getTodos(completion: @escaping (Response<[Todo]>) -> ()) {
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if response.result.isSuccess {
                var todos:[Todo] = []
                let data = JSON(rawValue: response.value!)
                data?.forEach({ (index, obj) in
                    let id = obj["id"].stringValue
                    let tempId = obj["tempId"].stringValue
                    let title = obj["title"].stringValue
                    let isCompleted = obj["is_completed"].stringValue == "1"
                    todos.append(Todo(id: id, title: title, isCompleted: isCompleted, tempId: tempId))
                })
                completion(Response.succeed(todos))
            }else{
                completion(Response.failed(message: "salah"))
            }
        }
    }
    func getTodo(id: String, completion: @escaping (Response<Todo>) -> ()) {
        
        Alamofire.request("\(url)/\(id)", method: .get).responseJSON { response in
            
            if response.result.isSuccess {
                let obj = JSON(rawValue: response.value!)!
                let id = obj["id"].stringValue
                let tempId = obj["tempId"].stringValue
                let title = obj["title"].stringValue
                let isCompleted = obj["is_completed"].stringValue == "1"
                let value = Todo(id: id, title: title, isCompleted: isCompleted, tempId: tempId)
                completion(Response.succeed(value))
            }else{
                completion(Response.failed(message: "salah"))
            }
        }
        
    }
    func updateTodo(todo: Todo, completion:@escaping (Response<Todo>) -> ()) {
        
        let params:[String:Any] = [
            "title":todo.title,
            "is_completed":todo.isCompleted
        ]
        Alamofire.request("\(url)/\(todo.id)", method: .put, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                let obj = JSON(rawValue: response.value!)!
                let id = obj["id"].stringValue
                let tempId = obj["tempId"].stringValue
                let title = obj["title"].stringValue
                let isCompleted = obj["is_completed"].stringValue == "1"
                let value = Todo(id: id, title: title, isCompleted: isCompleted, tempId: tempId)
                completion(Response.succeed(value))
            }else{
                completion(Response.failed(message: "salah"))
            }
        }
        
    }
    
    func addTodo(todo: Todo, completion: @escaping(Response<Todo>) -> ()) {
        let params:[String:Any] = [
            "tempId":todo.tempId,
            "title":todo.title,
            "is_completed":todo.isCompleted
        ]
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            
            if response.result.isSuccess {
                let obj = JSON(rawValue: response.value!)!
                let id = obj["id"].stringValue
                let tempId = obj["tempId"].stringValue
                let title = obj["title"].stringValue
                let isCompleted = obj["is_completed"].stringValue == "1"
                let value = Todo(id: id, title: title, isCompleted: isCompleted, tempId: tempId)
                completion(Response.succeed(value))
            }else{
                completion(Response.failed(message: "salah"))
            }
        }
        
    }
}
