//
//  UITableViewControllerExtension.swift
//  FinanceAPP
//
//  Created by Victor Prado on 24/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit

class UITableViewControllerExtension: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "logo"))
        let buttonUser = UIButton(type: .custom)
        let userImage = resizeImage(image: UIImage(named: "user")!, targetSize: CGSize(width: 30, height: 30))
        buttonUser.setImage(UIImage(named: "user")!.resize(targetSize: CGSize(width: 30, height: 30)), for: UIControlState())
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
    
    //MARK: - Utils
    
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
