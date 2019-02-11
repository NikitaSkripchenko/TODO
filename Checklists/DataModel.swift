//
//  DataModel.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/11/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import Foundation

class DataModel{
    var lists = [Checklist]()
    
    
    func documentsDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath()->URL{
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do{
                lists = try decoder.decode([Checklist].self, from: data)
            }catch{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveChecklist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
        }catch{
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

}
