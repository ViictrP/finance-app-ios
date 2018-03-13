//
//  SignupViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 22/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import TextFieldEffects
import MaterialComponents.MaterialSnackbar

class SignupViewController: UIViewController {

    @IBOutlet weak var tfName: KaedeTextField!
    @IBOutlet weak var tfEmail: KaedeTextField!
    @IBOutlet weak var tfPassword: KaedeTextField!
    @IBOutlet weak var tfConfirmPassword: KaedeTextField!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var btSignIn: UIButton!
    
    let api: UserAPI = UserAPI.shared
    var delegate: LoginViewController?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successView.transform = CGAffineTransform(translationX: 1, y: 0)
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
    
    @IBAction func signIn(_ sender: UIButton) {
        delegate?.autoComplete(user: user!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: UIButton) {
        user = User()
        user!.name = tfName.text!
        user!.email = tfEmail.text!
        user!.password = tfPassword.text!
        api.register(user: user!) { (success, error) in
            if error == nil {
                UIView.animate(withDuration: 0.3, animations: {
                    self.formView.isHidden = true
                    self.successView.isHidden = false
                })
            } else {
                self.doSnackbar(error!)
            }
        }
    }
    
    @IBAction func cancelRegister(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
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












