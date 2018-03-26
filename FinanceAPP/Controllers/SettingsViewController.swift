//
//  SettingsViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewControllerExtension {

    @IBOutlet weak var btLogout: UIButton!
    
    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let vc = segue.destination as! SettingsAuxViewController
        if segue.identifier == "themeSegue" {
            vc.hideTableView = false
        }
        if segue.identifier == "notificationHourSegue" {
            vc.hideTableView = true
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        defaults.set(nil, forKey: "accessToken")
        let mainApp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginController");
        mainApp.hero.modalAnimationType = .pageIn(direction: .left)
        self.hero.replaceViewController(with: mainApp)
    }
}
