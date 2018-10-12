//
//  ButtonTableViewCell.swift
//  Tasks
//
//  Created by Travis Chapman on 10/11/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    // MARK: - Constants & Variables
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        delegate?.buttonCellButtonTapped(self)
    }
}

// MARK: - Custom Functions
extension ButtonTableViewCell {
    
    func updateButton(_ isComplete: Bool) {
        
        if isComplete {
            completeButton.setImage(UIImage(named: "complete") , for: .normal)
        } else {
            completeButton.setImage(UIImage(named: "incomplete") , for: .normal)
        }
    }
    
    func update(withTask task: Task) {
        
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
}

protocol ButtonTableViewCellDelegate: class {

    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}
