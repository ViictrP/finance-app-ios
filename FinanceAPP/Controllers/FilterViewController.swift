//
//  FilterViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 08/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var lbModalTitle: UILabel!
    @IBOutlet weak var btCategory: UIButton!
    @IBOutlet weak var tfValue: UITextField!
    
    var delegate: HomeViewController?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfValue.attributedPlaceholder = changePlaceholder("By value...", with: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfValue.resignFirstResponder()
    }
    
    @IBAction func filterCategory(_ sender: UIButton) {
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func changePlaceholder(_ placeholder: String, with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
}
