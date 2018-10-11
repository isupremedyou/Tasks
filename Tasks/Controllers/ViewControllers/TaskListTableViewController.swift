//
//  TaskListTableViewController.swift
//  Tasks
//
//  Created by Travis Chapman on 10/10/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TaskController.shared.tasks.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }

        let task = TaskController.shared.tasks[indexPath.row]
        
        cell.update(withTask: task)
        cell.delegate = self

        return cell
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let task = TaskController.shared.tasks[indexPath.row]
            
            TaskController.shared.remove(task: task)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
        
        if segue.identifier == "toAddTask" {
            
            
        }
        
        if segue.identifier == "toEditTask" {
            
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.task = TaskController.shared.tasks[index]
            destinationVC.dueDateValue = TaskController.shared.tasks[index].due
            
        }
        
    }

}

extension TaskListTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        
        guard let task = sender.task else { return }
        
        TaskController.shared.toggleIsCompleteFor(task: task)
        
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    
    }
    
    
}
