//
//  TaskDetailTableViewController.swift
//  Tasks
//
//  Created by Travis Chapman on 10/10/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    // MARK: - Constants & Variables
    
    var dueDateValue: Date?
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDateTextField.inputView = dueDatePicker
        updateViews()
    }

    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let name = nameTextField.text, !name.isEmpty
            else { return }
        let due = dueDateValue
        let notes = notesTextView.text
        
        if task == nil {
            TaskController.shared.add(taskWithName: name, notes: notes, due: due)
        } else {
            guard let task = task else { return }
            TaskController.shared.update(task: task, name: name, notes: notes, due: due)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {

        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        dueDateValue = dueDatePicker.date
        dueDateTextField.text = dueDateValue?.stringValue()
    }
    
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
}

// MARK: - Functions

extension TaskDetailTableViewController {
    
    func updateViews() {
        
        loadViewIfNeeded()
        
        nameTextField.text = task?.name
        dueDateTextField.text = task?.due?.stringValue()
        notesTextView.text = task?.notes
        
    }
}

extension TaskDetailTableViewController: UITextViewDelegate, UITextFieldDelegate { }
