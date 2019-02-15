//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Nikita Skrypchenko  on 2/7/19.
//  Copyright © 2019 Nikita Skrypchenko . All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailV)
    func itemDetailViewController(_ controller: ItemDetailV, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailV, didFinishEditing item: ChecklistItem)
}

class ItemDetailV: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: AddItemViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker){
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit{
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }else{
            let item = ChecklistItem()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            return datePickerCell
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datePickerIsVisible && section == 1{
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func showDatePicker(){
        datePickerIsVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        datePicker.setDate(dueDate, animated: true)
        dueDateLabel.textColor = dueDateLabel.tintColor
    }
    
    func hideDatePicker(){
        datePickerIsVisible = false
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        dueDateLabel.textColor = .black
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1{
            if !datePickerIsVisible{
                showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 1 && indexPath.section == 1 {
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.row == 2 && indexPath.section == 1 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    
    // MARK:- Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
}
