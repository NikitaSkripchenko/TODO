//
//  utilities.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/11/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import Foundation
import UIKit

var items = [ChecklistItem]()

func documentsDirectory()->URL{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func dataFilePath()->URL{
    return documentsDirectory().appendingPathComponent("Checklist.plist")
}

func loadChecklistItems(){
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path){
        let decoder = PropertyListDecoder()
        do{
            items = try decoder.decode([ChecklistItem].self, from: data)
        }catch{
            print("Error: \(error.localizedDescription)")
        }
    }
}

func saveChecklistItems() {
    let encoder = PropertyListEncoder()
    do {
        let data = try encoder.encode(items)
        try data.write(to: dataFilePath(),
                       options: Data.WritingOptions.atomic)
    }catch{
        print("Error encoding item array: \(error.localizedDescription)")
    }
}
