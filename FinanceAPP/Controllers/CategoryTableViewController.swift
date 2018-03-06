//
//  CategoryTableViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 26/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewControllerExtension {
    
    private var defaults = UserDefaults.standard
    private let api: InvoiceAPI = InvoiceAPI.shared
    var categories: [Category] = []
    var delegate: UITableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let loadedFromAPI = defaults.value(forKey: "loadedFromAPI") as? Bool ?? false
        print(loadedFromAPI)
        if !loadedFromAPI {
            api.getCategories(accessToken: defaults.string(forKey: "accessToken")!) { (categories) in
                if let cat = categories {
                    self.categories = cat
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            let realm = try! Realm()
            let result = realm.objects(Category.self)
            categories = Array(result)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let result = realm.objects(Category.self)
        categories = Array(result)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        if let vc = delegate as? EditInvoiceViewController  {
            vc.category = category
            navigationController?.popViewController(animated: true)
            return
        }
        if let vc = delegate as? AddInvoiceViewController {
            vc.category = category
            navigationController?.popViewController(animated: true)
            return
        }
    }
}
