//
//  RepositoryPatterinInProjectTests.swift
//  RepositoryPatterinInProjectTests
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import XCTest
@testable import RepositoryPatterinInProject

class RepositoryPatterinInProjectTests: XCTestCase {
    
    var remoteRepository: Repository?
    
    override func setUp() {
        super.setUp()
        remoteRepository = RemoteRepository()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGettingTodosFromRemote(){
        let expect = expectation(description: "getting todos from remote")
        remoteRepository?.getTodos { result in
            switch result {
            case .failed(message: _):
                XCTFail()
                break;
            case .succeed(let todos):
                XCTAssertTrue(todos.count>0)
                break;
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 10)
    }
    func testGettingTodoById(){
        let selectedId = 1
        let expect = expectation(description: "getting todo by id from remote")
        remoteRepository?.getTodo(id: "") { result in
            switch result {
            case .failed(message: _):
                XCTFail()
                break;
            case .succeed(let todo):
                print(todo.title)
                print(todo.isCompleted)
                XCTAssertNotNil(todo)
                break;
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 10)
    }
    
    func testAddTodo(){
        let todoCandidate = Todo(title: "coding3", isCompleted: false, tempId: UUID().uuidString)
        let expect = expectation(description: "add todo to remote")
        remoteRepository?.addTodo(todo: todoCandidate) { result in
            switch result {
            case .failed(message: _):
                XCTFail()
                break;
            case .succeed(let todo):
                print("updated todo \(todo.title)")

                XCTAssertNotNil(todo)
                break;
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 10)

    }
    
    func testUpdateTodoItem(){
        let expect = expectation(description: "getting todo by id from remote")
        let todo = Todo(id:"HkcFp6QtW", title: "bebek", isCompleted: false)
        remoteRepository?.updateTodo(todo: todo, completion: { rs in
            switch rs {
            case .failed(message: _):
                XCTFail()
                break;
            case .succeed(let todo):
                print("updated todo \(todo.title)")
                XCTAssertNotNil(todo)
                break;
            }
            expect.fulfill()
        })
        wait(for: [expect], timeout: 10)
    }
    
}
