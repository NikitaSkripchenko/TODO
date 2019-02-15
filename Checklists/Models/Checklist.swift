//
//  Checklist.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/9/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String){
        self.name = name
        super.init()
    }
}
