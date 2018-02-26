//
//  StarterViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 26/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class StarterViewController: UIViewController {

    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let _ = defaults.string(forKey: "accessToken") else {
            changeView("loginController")
            return
        }
        changeView("mainApp")
    }
    
    func changeView(_ identifier: String) {
        let mainApp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier);
        mainApp.hero.modalAnimationType = .pageIn(direction: .left)
        self.hero.replaceViewController(with: mainApp)
    }
}
