//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/6/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var checklist: Checklist!
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailV) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailV, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        //saveChecklistItems()
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailV, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailV
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailV
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckMark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        //label.text = "\(item.itemId): \(item.text)"
    }
    
    func configureCheckMark(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✅"
        } else {
            label.text = "  "
        }
    }
    
    func configureDate(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1002) as! UILabel
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: item.dueDate)
        label.text = newDate
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "Checklistitem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckMark(for: cell, with: item)
        configureDate(for: cell, with: item)
        return cell
    }
    
    //swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
}
