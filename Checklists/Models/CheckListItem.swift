//
//  CheckListItem.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/6/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import Foundation
class ChecklistItem: NSObject, Codable{
    var text = ""
    var checked = false
    var dueDate = Date()
    var itemId = -1 //id is special keyword in obj-c
    var shouldRemind = false
    
    func toggleChecked(){
        checked = !checked
    }
    
    override init(){
        super.init()
        itemId = DataModel.nextChecklistItemId()
    }
}
