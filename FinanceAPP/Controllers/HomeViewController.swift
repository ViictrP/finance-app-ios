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
    let titles: [String] = ["Itaucard", "Nubank", "Casas Bahia", "iPlace", "Tentbeach", "C&A", "Pernambucanas", "NET", "Notebook", "Faculdade"]
    let values: [String] = ["R$435,50", "R$270,45", "R$179,90", "R$415,89", "R$260,00", "R$50,00", "R$117,98", "R$223,20", "R$382,90", "R$98,00"]
    let expires: [String] = ["09/03", "23/03", "15/03", "20/03", "20/03", "09/03", "15/03", "20/03", "09/03", "09/03"]
    let installments: [String] = ["1x", "1x", "10x", "10x", "12x", "12x", "9x", "--", "12x", "4x"]
    let categories: [InvoiceCategory] = [.creditCard, .creditCard, .creditCard, .creditCard, .creditCard, .creditCard, .creditCard, .homeExpenses, .creditCard, .creditCard]
    var invoices: [Invoice] = []
    
    var oldCalendarHeight = CGFloat(300)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.setScope(.week, animated: true)
        calendarHeightConstraint.constant = 120
        for i in 0...9 {
            invoices.append(Invoice(title: titles[i], value: values[i], expireDate: expires[i], installment: installments[i], category: categories[i]))
        }
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
    
    func changeImages(_ image: String, for sender: UIBarButtonItem, constant: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.image = UIImage(named: image)
            self.calendarHeightConstraint.constant = constant
            self.view.layoutIfNeeded()
        })
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "financeCell", for: indexPath) as! FinanceTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        let invoice = invoices[indexPath.row]
        cell.invoiceTitle.text = invoice.title
        cell.invoiceValue.text = invoice.value
        cell.expireDate.text = invoice.expireDate
        cell.invoiceInstallmentCount.text = invoice.installment
        cell.invoiceCategory.text = invoice.category.rawValue
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










