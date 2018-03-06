//
//  HomeViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import FSCalendar
import MaterialComponents.MaterialSnackbar
import RealmSwift

class HomeViewController: UIViewControllerExtension {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultContainer: UIView!
    @IBOutlet weak var btSync: UIBarButtonItem!
    
    var invoices: [Invoice] = []
    var oldCalendarHeight = CGFloat(300)
    private var api: InvoiceAPI = InvoiceAPI.shared
    private var defaults = UserDefaults.standard
    var apiRequested: Bool = false
    var uiBusy: UIActivityIndicatorView = {
        let uibusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
        uibusy.hidesWhenStopped = true
        uibusy.startAnimating()
        return uibusy
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.setScope(.week, animated: true)
        calendarHeightConstraint.constant = 120
        getInvoices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invoices = []
        tableView.reloadData()
        let realm = try! Realm()
        let results = realm.objects(Invoice.self)
        invoices = Array(results)
        if invoices.count > 0 {
            noResultContainer.isHidden = true
        } else {
            noResultContainer.isHidden = false
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? InvoiceViewController {
            let invoice = invoices[tableView.indexPathForSelectedRow!.row]
            vc.invoice = invoice
        }
    }
    
    @IBAction func toggleScope(_ sender: UIBarButtonItem) {
        switch calendar.scope {
            case .month:
                changeImages("icons8-expand-filled", for: sender, constant: 120)
                calendar.setScope(.week, animated: true)
            case .week:
                changeImages("icons8-collapse-filled", for: sender, constant: oldCalendarHeight)
                calendar.setScope(.month, animated: true)
        }
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func sync(_ sender: UIBarButtonItem) {
        sender.customView?.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: uiBusy)
        getInvoices()
    }
    
    func changeImages(_ image: String, for sender: UIBarButtonItem, constant: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.image = UIImage(named: image)
            self.calendarHeightConstraint.constant = constant
            self.view.layoutIfNeeded()
        })
    }
    
    func getInvoices() {
        api.getInvoices(params: [:]) { (invoices) in
            if let inv = invoices {
                self.invoices = inv
                if self.invoices.count == 0 {
                    let realm = try! Realm()
                    let result = realm.objects(Invoice.self)
                    try! realm.write {
                        realm.delete(result)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.apiRequested = true
                    self.navigationItem.leftBarButtonItem = self.btSync
                    if inv.count <= 0 {
                        self.noResultContainer.isHidden = false
                    } else {
                        self.noResultContainer.isHidden = true
                    }
                }
            }
        }
    }
    
    func doSnackbar(_ msg: String) {
        let message = MDCSnackbarMessage()
        message.text = msg
        MDCSnackbarManager.show(message)
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let expireDate = DateUtils.dateToString(date)
        api.getInvoices(params: ["expireDate": expireDate]) { (invoices) in
            if let inv = invoices {
                self.invoices = inv
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if inv.count <= 0 {
                        self.noResultContainer.isHidden = false
                    } else {
                        self.noResultContainer.isHidden = true
                    }
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "financeCell", for: indexPath) as! FinanceTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        let invoice = invoices[indexPath.row]
        cell.prepare(invoice: invoice)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editInvoice", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Pay") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            let invoice = self.invoices[indexPath.row]
            self.api.makePayment(value: invoice.totalPaid, invoice: invoice, completionHandler: { (success, error) in
                if error == nil {
                    let realm = try! Realm()
                    try! realm.write {
                        invoice.totalPaid = invoice.value
                    }
                    self.doSnackbar("invoice \(invoice.title) was paid")
                    let cell = tableView.cellForRow(at: indexPath) as! FinanceTableViewCell
                    cell.paidInvoice(true)
                    invoice.paid = true
                } else {
                    self.doSnackbar(error!)
                }
            })
            completionHandler(true)
        }
        action.image = UIImage(named: "paid")
        action.backgroundColor = UIColor(named: "main_green")
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            let invoice = self.invoices[indexPath.row]
            let title = String(invoice.title)
            self.api.deleteInvoice(invoice: invoice, completionHandler: { (success, error) in
                if error == nil {
                    self.doSnackbar("Invoice \(title) was removed")
                    self.invoices.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.invoices.count <= 0 {
                            self.noResultContainer.isHidden = false
                        }
                    }
                } else {
                    self.doSnackbar(error!)
                }
            })
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = UIColor(named: "main_red")
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, action])
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Time to delete this...")
        }
    }
}










