//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Travis Chapman on 10/10/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation

extension Task {
    
    convenience init(name: String, notes: String? = nil, due: Date? = nil, isComplete: Bool, context: CoreDataStack.managedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.
        
    }
    
}
