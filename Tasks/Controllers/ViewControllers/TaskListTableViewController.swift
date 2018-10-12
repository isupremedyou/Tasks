//
//  TaskListTableViewController.swift
//  Tasks
//
//  Created by Travis Chapman on 10/11/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskController.shared.fetchedResultsController.delegate = self
    }
}

// MARK: - Functions

extension TaskListTableViewController {
    
    // Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = TaskController.shared.fetchedResultsController.sections else { return 0 }
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath)
            as? ButtonTableViewCell
            else { return UITableViewCell() }
        
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.update(withTask: task)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        guard let sections = TaskController.shared.fetchedResultsController.sections else { return "No Section" }
        guard let sectionIndexTitle = sections[section].indexTitle else { return "No Section" }
        
        let sectionIndex = Int(sectionIndexTitle)
        
        if sectionIndex == 0 {
            return "Incomplete"
        } else {
            return "Complete"
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        if editingStyle == .delete {
            TaskController.shared.remove(task: task)
        }
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
        
        if segue.identifier == "toEditTask" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
            
            destinationVC.task = task
            destinationVC.dueDateValue = task.due
        }
    }
}

// MARK: - Delegate Functions

extension TaskListTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        
        TaskController.shared.toggleIsCompleteFor(task: task)
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .delete :
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert :
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move :
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update :
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move:
            break
        case .update:
            break
        }
    }
}
