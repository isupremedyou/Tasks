//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Travis Chapman on 10/10/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(name: String, notes: String?, due: Date?, context: NSManagedObjectContext = CoreDataStack.managedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        self.due = due
        
    }
    
}
