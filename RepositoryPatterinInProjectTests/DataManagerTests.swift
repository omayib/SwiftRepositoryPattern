//
//  DataManagerTests.swift
//  RepositoryPatterinInProject
//
//  Created by qiscus on 8/30/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import XCTest
@testable import RepositoryPatterinInProject

class DataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGettingDataAtFirstTime() {
        
        let dataManager = DataManager()
        let expt = expectation(description: "getting data first time using data manager")
        dataManager.delegate = MockGettingDataListener(expectation: expt)
        dataManager.getTodos()
        
        wait(for: [expt], timeout: 10)
    }
    
    func testGettingDataAtSecondTime(){
        
        let dataManager = DataManager()
        
        let expt = expectation(description: "getting data at second time using data manager")
        dataManager.delegate = MockGettingDataAtFirstTimeListener(expectation: expt)
        dataManager.getTodos()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            dataManager.delegate = MockGettingDataAtSecondTimeListener(expectation: expt)
            dataManager.getTodos()
        }
        
        wait(for: [expt], timeout: 15)
    }
    
    func testAddingNewItem(){
        let dataManager = DataManager()
        let expt = expectation(description: "adding new item using data manager")
        dataManager.delegate = MockAddingNewItemListener(expectation: expt)
        dataManager.getTodos()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            let cadidate = Todo(title: "takbiran5", isCompleted: false, tempId: UUID().uuidString)
            dataManager.addTodo(todoCandidate: cadidate)
        }
        wait(for: [expt], timeout: 10)
    }
    
    func testUpdatingTodoInFailure(){
        let selectedTodo = Todo(title: "baca koran", isCompleted: false, tempId: "710BBEC4-8A7B-486F-9329-412DFD5FB738")
        
        let dataManager = DataManager()
        let expt = expectation(description: "updating an existing item using data manager")
        dataManager.delegate = MockUpdatingTodoInFailure(expectation: expt)
        dataManager.getTodos()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            dataManager.updateTodo(todo: selectedTodo)
        }
        wait(for: [expt], timeout: 10)
    }
}


class MockUpdatingTodoInFailure: DataManagerDelegate {
    let expt : XCTestExpectation?
    var todos: TodoCollection?

    init(expectation: XCTestExpectation) {
        self.expt = expectation
        self.todos = TodoCollection(todos: [])
    }
    func dataDidLoad(todos: TodoCollection) {
        self.todos = todos
        XCTAssertNotNil(todos)
    }
    func dataTransactionFailure(errorMessage: String) {
        XCTAssertNotNil(errorMessage)
        expt?.fulfill()
    }
    func dataDidChanged() {}
    func dataTransactionSucceed() {}
}

class MockAddingNewItemListener: DataManagerDelegate {
    let expt : XCTestExpectation?
    var todos: TodoCollection?
    var sizeBeforeAdded: Int = 0
    init(expectation: XCTestExpectation) {
        self.expt = expectation
        self.todos = TodoCollection(todos: [])
    }
    
    func dataDidLoad(todos: TodoCollection) {
        self.todos = todos
        self.sizeBeforeAdded = (self.todos?.value.count)!
        XCTAssertNotNil(self.todos)
    }
    func dataTransactionFailure(errorMessage: String) {
        XCTAssertNotNil(errorMessage)
    }
    func dataDidChanged() {
        print("sapi1 \(self.todos?.value.count)")
        self.todos?.value.forEach({ t in
            print("\(t.title) ; \(t.tempId); \(t.id)")
        })
        XCTAssertTrue(self.sizeBeforeAdded < (self.todos?.value.count)!)
      
    }
    func dataTransactionSucceed() {
        print("sapi2 \(self.todos?.value.count)")
        self.todos?.value.forEach({ t in
            print("\(t.title) ; \(t.tempId); \(t.id)")
        })
        XCTAssertTrue(self.sizeBeforeAdded < (self.todos?.value.count)!)
        self.expt?.fulfill()
        
    }
}

class MockGettingDataAtSecondTimeListener: DataManagerDelegate {
    
    let expt : XCTestExpectation?
    
    init(expectation: XCTestExpectation) {
        self.expt = expectation
    }
    
    func dataDidLoad(todos:TodoCollection) {
        XCTAssertNotNil(todos)
        self.expt?.fulfill()
    }
    func dataTransactionFailure(errorMessage: String) {
        print("b")
        XCTAssertNotNil(errorMessage)
        self.expt?.fulfill()
    }
    func dataDidChanged() {
        print("c")
        self.expt?.fulfill()
    }
    func dataTransactionSucceed() {
        
    }
}
class MockGettingDataAtFirstTimeListener: DataManagerDelegate{
    
    let expt : XCTestExpectation?
    init(expectation: XCTestExpectation) {
        self.expt = expectation
    }
    func dataDidLoad(todos: TodoCollection) {
        XCTAssertNotNil(todos)
    }
    func dataTransactionFailure(errorMessage: String) {
        XCTAssertNotNil(errorMessage)
    }
    func dataDidChanged() {
    }
    func dataTransactionSucceed() {
        
    }
}

class MockGettingDataListener: DataManagerDelegate{
    
    let expt : XCTestExpectation?
    init(expectation: XCTestExpectation) {
        self.expt = expectation
    }
    func dataDidLoad(todos: TodoCollection) {
        XCTAssertNotNil(todos)
        self.expt?.fulfill()
    }
    func dataTransactionFailure(errorMessage: String) {
        XCTAssertNotNil(errorMessage)
        self.expt?.fulfill()
    }
    func dataDidChanged() {
        self.expt?.fulfill()
    }
    func dataTransactionSucceed() {
        
    }
}
