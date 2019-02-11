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
    
    func toggleChecked(){
        checked = !checked
    }
}
