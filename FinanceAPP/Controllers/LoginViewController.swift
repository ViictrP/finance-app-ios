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
import MaterialComponents.MaterialSnackbar

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var btSignUp: UIButton!
    @IBOutlet weak var tfUsername: KaedeTextField!
    @IBOutlet weak var tfPassword: KaedeTextField!
    @IBOutlet weak var btLoginWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var lbError: UILabel!
    
    let api: LoginAPI = LoginAPI.shared
    var constant = 300
    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = defaults.string(forKey: "accessToken") else {return}
        changeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignupViewController {
            vc.delegate = self
        }
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponderAll()
    }

    @IBAction func login(_ sender: UIButton) {
        animate(constant: 45, hide: false, title: "")
        api.authenticate(email: tfUsername.text!, password: tfPassword.text!) { (response) in
            if response == "ok" {
                self.changeView()
                return
            }
            self.animate(constant: CGFloat(self.constant), hide: true, title: "Sign in")
            self.lbError.isHidden = false
            self.lbError.text = response
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    func changeView() {
        let mainApp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApp");
        mainApp.hero.modalAnimationType = .pageIn(direction: .left)
        self.hero.replaceViewController(with: mainApp)
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
    
    func animate(constant: CGFloat, hide activityIsHidden: Bool, title: String) {
        UIView.animate(withDuration: 0.2) {
            self.activityIndicator.isHidden = activityIsHidden
            self.btLogin.setTitle(title, for: UIControlState())
            self.btLoginWidthConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
    func autoComplete(user: User) {
        tfUsername.text = user.email
        tfPassword.text = user.password
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







