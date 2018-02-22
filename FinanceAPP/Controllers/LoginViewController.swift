//
//  LoginViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import Hero
import TextFieldEffects
import DeckTransition

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var btSignUp: UIButton!
    @IBOutlet weak var tfUsername: KaedeTextField!
    @IBOutlet weak var tfPassword: KaedeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponderAll()
    }

    @IBAction func login(_ sender: UIButton) {
        let mainApp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApp");
        mainApp.hero.modalAnimationType = .pageIn(direction: .left)
        self.hero.replaceViewController(with: mainApp)
    }
    
    private func resignFirstResponderAll() {
        tfUsername.resignFirstResponder()
        tfPassword.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUsername {
            tfPassword.becomeFirstResponder()
        } else {
            resignFirstResponderAll()
        }
        return false
    }
}







