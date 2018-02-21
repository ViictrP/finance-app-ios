//
//  LoginViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import Hero

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func login(_ sender: UIButton) {
        let mainApp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApp");
        mainApp.hero.modalAnimationType = .pageIn(direction: .left)
        self.hero.replaceViewController(with: mainApp)
    }
    
}
