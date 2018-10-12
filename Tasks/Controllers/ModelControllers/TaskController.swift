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
    
    let fetchedResultsController: NSFetchedResultsController<Task> = {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let isCompleteSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        let dueSortDescriptor = NSSortDescriptor(key: "due", ascending: false)

        request.sortDescriptors = [isCompleteSortDescriptor, dueSortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
    }()
    
    init() {
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error with initial fetch request: \(error.localizedDescription)")
        }
        
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
        
        let moc = CoreDataStack.context
        
        moc.delete(task)
        
        saveToPersistentStore()
        
    }
    
    func saveToPersistentStore() {
        
        let moc = CoreDataStack.context
        
        do {
            try moc.save()
        } catch let error {
            print("Error saving to CoreData persistence store \(error.localizedDescription)")
        }
        
    }
    
}
