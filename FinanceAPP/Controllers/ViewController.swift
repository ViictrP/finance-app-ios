//
//  ViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 20/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController {

    @IBOutlet weak var viView: UIView!
    @IBOutlet weak var btButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "show", sender: nil)
    }
}

