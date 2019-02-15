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
    
    var indexOfSelectChecklist: Int{
        get{
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func nextChecklistItemId ()-> Int{
        let userDefaults = UserDefaults.standard
        let itemId = userDefaults.integer(forKey: "ChecklistItemId")
        userDefaults.set(itemId + 1, forKey: "ChecklistItemId")
        userDefaults.synchronize()
        return itemId
    }
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true ] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime{
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
            
        }
    }
    
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
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
            print(dataFilePath())
        }catch{
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

}
