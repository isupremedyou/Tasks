//
//  TaskController.swift
//  Tasks
//
//  Created by Travis Chapman on 10/11/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    // Shared Instance
    static var shared = TaskController()
    
    // Shared Truth
    var tasks: [Task] {
        return fetchTasks()
    }
    
    
    // MARK: - CRUD Functions
    
    func add(taskWithName name: String, notes: String?, due: Date?) {
        
        let _ = Task(name: name, notes: notes, due: due)
        
        saveToPersistentStore()
        
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?) {
        
        task.name = name
        task.notes = notes
        task.due = due
        
        saveToPersistentStore()
        
    }
    
    func toggleIsCompleteFor(task: Task) {
        task.isComplete = !task.isComplete
    }
    
    func remove(task: Task) {
        
        let moc = CoreDataStack.managedObjectContext
        
        moc.delete(task)
        
        saveToPersistentStore()
        
    }
    
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.managedObjectContext
        
        do {
            try moc.save()
        } catch let error {
            print("Error saving to CoreData persistence store \(error.localizedDescription)")
        }
        
    }
   
    func fetchTasks() -> [Task] {
        
        let moc = CoreDataStack.managedObjectContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        return (try? moc.fetch(fetchRequest)) ?? []
        
    }
    
}
