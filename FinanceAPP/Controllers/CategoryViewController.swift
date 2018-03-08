//
//  CategoryViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 06/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialSnackbar

class CategoryViewController: UIViewControllerExtension {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btAddCategory: UIBarButtonItem!
    
    var categories: [Category]? = []
    var api: CategoryAPI = CategoryAPI.shared
    var aiBusy: UIActivityIndicatorView = {
        let busy = UIActivityIndicatorView(activityIndicatorStyle: .white)
        busy.hidesWhenStopped = true
        busy.startAnimating()
        return busy
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: aiBusy)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aiBusy.startAnimating()
        let realm = try! Realm()
        let results = realm.objects(Category.self)
        categories = Array(results)
        for var category in categories! {
            api.getCategoryInfo(category, completionHandler: { (categoryUpdated, error) in
                if error == nil {
                    if let cat = categoryUpdated {
                        if cat.id == category.id {
                            category = cat
                        }
                    }
                    self.aiBusy.stopAnimating()
                    self.collectionView.reloadData()
                } else {
                    self.aiBusy.stopAnimating()
                    self.doSnackbar(error!)
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "addEditCategorySegue", let vc = segue.destination as? AddEditCategoryTableViewController {
            let cell = sender as! CategoryCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            let category = categories![indexPath!.row]
            vc.category = category
        }
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories![indexPath.row]
        cell.prepare(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addEditCategorySegue", sender: collectionView.cellForItem(at: indexPath))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 72
        return CGSize(width: collectionView.bounds.width, height: CGFloat(height))
    }
}
