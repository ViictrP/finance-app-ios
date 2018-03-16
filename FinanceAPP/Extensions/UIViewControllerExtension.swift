//
//  UIViewControllerExtension.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import Hero

class UIViewControllerExtension: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "logo"))
        let buttonUser = UIButton(type: .custom)
        buttonUser.setImage(UIImage(named: "user")!.resize(targetSize: CGSize(width: 30, height: 30)), for: UIControlState())
        buttonUser.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonUser.imageView?.contentMode = .scaleAspectFit
        buttonUser.imageView?.clipsToBounds = true
        buttonUser.clipsToBounds = true
        buttonUser.cornerRadius = 15
        buttonUser.hero.id = "userImage"
        buttonUser.addTarget(self, action: #selector(doAction), for: .touchUpInside)
        imageView.hero.id = "logo"
        self.navigationItem.titleView = imageView
        let uiBarButtonUser = UIBarButtonItem(customView: buttonUser)
        let items: [UIBarButtonItem] = self.navigationItem.rightBarButtonItems ?? []
        self.navigationItem.rightBarButtonItems = [uiBarButtonUser]
        self.navigationItem.rightBarButtonItems?.append(contentsOf: items)
        self.navigationController?.view.hero.id = "userView"
        
        //TAB BAR
        let tabBarItems: [UITabBarItem] = self.tabBarController!.tabBar.items!
        for tabBarItem in tabBarItems {
            tabBarItem.title = nil
            tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UserViewController {
            vc.userImage = UIImage(named: "user")
        }
    }
    
    @objc func doAction() {
        performSegue(withIdentifier: "userModal", sender: nil)
    }
}
