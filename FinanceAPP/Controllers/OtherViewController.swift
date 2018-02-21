//
//  OtherViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 20/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    @IBOutlet weak var btVoltar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btVoltarAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
