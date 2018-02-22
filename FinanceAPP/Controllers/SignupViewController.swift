//
//  SignupViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 22/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import TextFieldEffects

class SignupViewController: UIViewController {

    @IBOutlet weak var tfName: KaedeTextField!
    @IBOutlet weak var tfEmail: KaedeTextField!
    @IBOutlet weak var tfPassword: KaedeTextField!
    @IBOutlet weak var tfConfirmPassword: KaedeTextField!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponderAll()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func resignFirstResponderAll() {
        tfName.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        tfConfirmPassword.resignFirstResponder()
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case tfName:
                tfEmail.becomeFirstResponder()
            case tfEmail:
                tfPassword.becomeFirstResponder()
            case tfPassword:
                tfConfirmPassword.becomeFirstResponder()
            case tfPassword:
                resignFirstResponderAll()
            default:
                resignFirstResponderAll()
        }
        return false
    }
}












