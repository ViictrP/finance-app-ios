//
//  FilterViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 08/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import RealmSwift

class FilterViewController: UIViewController {

    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var lbModalTitle: UILabel!
    @IBOutlet weak var btCategory: UIButton!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var viForm: UIView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var delegate: HomeViewController?
    var categories: [Category]?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfValue.attributedPlaceholder = changePlaceholder("By value...", with: .lightGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let results = realm.objects(Category.self)
        categories = Array(results)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfValue.resignFirstResponder()
    }
    
    @IBAction func filterCategory(_ sender: UIButton) {
        showHide(false)
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: UIButton) {
    }
    
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
    func animate(_ time: Double, _ alpha: CGFloat, _ showOrHide: Bool) {
        UIView.animate(withDuration: time) {
            self.lbModalTitle.alpha = alpha
            self.lbModalTitle.isHidden = !showOrHide
            self.viForm.alpha = alpha
            self.viForm.isHidden = !showOrHide
            self.categoryTableView.isHidden = showOrHide
            self.categoryTableView.alpha = showOrHide ? 0.0 : 1
        }
    }
    
    func showHide(_ bool: Bool) {
        if bool {
            animate(0.2, 1.0, bool)
        } else {
            animate(0.2, 0.0, bool)
        }
    }
}

public class FilterCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterCell
        let category = categories![indexPath.row]
        cell.label.text = category.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = categories![indexPath.row]
        btCategory.setTitle(category!.title, for: UIControlState())
        showHide(true)
    }
}

























