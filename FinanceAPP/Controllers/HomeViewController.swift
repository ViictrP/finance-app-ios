//
//  HomeViewController.swift
//  FinanceAPP
//
//  Created by Victor Prado on 21/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewControllerExtension {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultContainer: UIView!
    
    var invoices: [Invoice] = []
    var oldCalendarHeight = CGFloat(300)
    private var api: InvoiceAPI = InvoiceAPI.shared
    private var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.setScope(.week, animated: true)
        calendarHeightConstraint.constant = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInvoices()
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
    
    func changeImages(_ image: String, for sender: UIBarButtonItem, constant: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.image = UIImage(named: image)
            self.calendarHeightConstraint.constant = constant
            self.view.layoutIfNeeded()
        })
    }
    
    func getInvoices() {
        api.getInvoices(accessToken: defaults.string(forKey: "accessToken")!, params: nil) { (invoices) in
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

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {

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
            completionHandler(true)
        }
        action.image = UIImage(named: "paid")
        action.backgroundColor = UIColor(named: "main_green")
        let swipeConfig = UISwipeActionsConfiguration(actions: [action])
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Time to delete this...")
        }
    }
}










