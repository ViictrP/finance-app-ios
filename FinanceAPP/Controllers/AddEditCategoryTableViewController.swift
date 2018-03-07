//
//  AddEditCategoryTableViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 07/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import RealmSwift

class AddEditCategoryTableViewController: UITableViewControllerExtension {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var aiBusy: UIActivityIndicatorView!
    @IBOutlet weak var btDelete: UIButton!
    
    var category: Category?
    var api: CategoryAPI = CategoryAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aiBusy.stopAnimating()
        tfTitle.attributedPlaceholder = changePlaceholder("Title...", with: .lightGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let category = category {
            btDelete.isHidden = false
            tfTitle.text = category.title
        } else {
            btDelete.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfTitle.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: UIButton) {
        tfTitle.resignFirstResponder()
        let checked = checkValue()
        if checked {
            if category == nil {
                category = Category()
                category!.title = tfTitle.text!
                api.saveCategory(category!, completionHandler: { (success, error) in
                    if error == nil {
                        self.doSnackbar("Category \(self.category!.title) was added")
                        self.cancel(self.btSave)
                    } else {
                        self.doSnackbar(error!)
                    }
                })
            } else {
                let realm = try! Realm()
                try! realm.write {
                    category!.title = tfTitle.text!
                }
                api.updateCategory(category!, completionHandler: { (success, error) in
                    if error == nil {
                        self.doSnackbar("Category \(self.category!.title) was updated")
                        self.cancel(self.btSave)
                    } else {
                        self.doSnackbar(error!)
                    }
                })
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        tfTitle.resignFirstResponder()
        category = nil
        tfTitle.text = ""
        tfTitle.backgroundColor = UIColor(named: "textfield_bg_color")
        tfTitle.attributedPlaceholder = changePlaceholder("Title...", with: .lightGray)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteCategory(_ sender: UIButton) {
    }
    
    func checkValue() -> Bool {
        var checked = true
        if tfTitle.text!.isEmpty {
            checked = false
            tfTitle.backgroundColor = UIColor(named: "main_red")
            tfTitle.attributedPlaceholder = changePlaceholder("This value is required...", with: .white)
        }
        return checked
    }
    
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
}
