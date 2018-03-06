//
//  UserViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import RealmSwift

class UserViewController: UIViewController {

    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var btEdit: UIButton!
    @IBOutlet weak var btEditPic: UIButton!
    
    var userImage: UIImage?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            for cell in collectionView.visibleCells {
                (cell as! SettingsCollectionViewCell).enableTextField(false)
            }
            sender.setTitle("Edit", for: UIControlState())
        }
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













