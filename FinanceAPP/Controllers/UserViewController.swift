//
//  UserViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialSnackbar

class UserViewController: UIViewController {

    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var btEdit: UIButton!
    @IBOutlet weak var btEditPic: UIButton!
    @IBOutlet weak var aiBusy: UIActivityIndicatorView!
    
    var userImage: UIImage?
    var user: User?
    var api: UserAPI = UserAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aiBusy.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ivUser.image = userImage!
        let realm = try! Realm()
        let result = realm.objects(User.self)
        let array = Array(result)
        user = array.first!
    }
    

    @IBAction func voltarAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func editForm(_ sender: UIButton) {
        if sender.titleLabel?.text == "Edit" {
            for cell in collectionView.visibleCells {
                (cell as! SettingsCollectionViewCell).enableTextField(true)
            }
            sender.setTitle("Save", for: UIControlState())
        } else {
            sender.setTitle("", for: UIControlState())
            aiBusy.startAnimating()
            user = User()
            var values: [String] = []
            for cell in collectionView.visibleCells {
                if let cell = cell as? SettingsCollectionViewCell {
                  cell.enableTextField(false)
                  values.append(cell.lbValue.text!)
                }
            }
            user?.name = values[0]
            user?.email = values[1]
            user?.password = values[2]
            api.updateInfo(user: user!, completionHandler: { (success, error) in
                self.aiBusy.stopAnimating()
                if error == nil {
                    sender.setTitle("Edit", for: UIControlState())
                    self.doSnackbar("Information was updated, remember to save your new password.")
                } else {
                    self.doSnackbar(error!)
                    sender.setTitle("Save", for: UIControlState())
                }
            })
        }
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
    
    @IBAction func editPic(_ sender: UIButton) {
    }
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsCollectionViewCell.fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell", for: indexPath) as! SettingsCollectionViewCell
        var value = ""
        switch SettingsCollectionViewCell.fields[indexPath.row] {
            case "Name":
                value = user!.name
                cell.textField.keyboardType = .default
            case "Email":
                value = user!.email
                cell.textField.keyboardType = .emailAddress
            case "Password":
                value = "**********"
                cell.textField.keyboardType = .default
            case "Other":
                value = "R$3000.00"
                cell.textField.keyboardType = .numberPad
            default:
                value = ""
                cell.textField.keyboardType = .default
        }
        cell.prepare(field: SettingsCollectionViewCell.fields[indexPath.row], value: value)
        return cell
    }
}













