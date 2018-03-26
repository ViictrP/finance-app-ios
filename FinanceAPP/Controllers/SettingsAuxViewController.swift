//
//  SettingsAuxViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 26/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class SettingsAuxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dtNotificationHour: UIDatePicker!
    
    var hideTableView: Bool = false
    var themeOptions: [String] = ["Dark theme", "Light Theme"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dtNotificationHour.setValue(UIColor.white, forKey: "textColor")
        tableView.isHidden = hideTableView
        dtNotificationHour.isHidden = !hideTableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = themeOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}
