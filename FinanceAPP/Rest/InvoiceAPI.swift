//
//  InvoiceAPI.swift
//  FinanceAPP
//
//  Created by Victor Prado on 24/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import RealmSwift

public class InvoiceAPI {
    
    private let endpoint: String = "/invoices"
    private var defaults = UserDefaults.standard
    private var categoryAPI: CategoryAPI = CategoryAPI.shared
    
    public static var shared: InvoiceAPI = {
        let invoiceAPI = InvoiceAPI()
        return invoiceAPI
    }()
    
    private init() {
        
    }
    
    public func getInvoices(params: Parameters, completionHandler: @escaping([Invoice]?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .get, parameters: params, encoding: URLEncoding(destination: .queryString), headers: headers).responseArray(keyPath: "data") {(response: DataResponse<[Invoice]>) in
            let invoices = response.result.value
            switch response.result {
            case .success:
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    self.categoryAPI.getCategories { (categories) in
                        if let _ = categories, let invoices = invoices {
                            self.defaults.set(true, forKey: "loadedFromAPI")
                            self.saveInvoices(invoices)
                            completionHandler(invoices)
                        }
                    }
                } else {
                    completionHandler([])
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler([])
            }
        }
    }
    
    public func getCategories(accessToken: String, completionHandler: @escaping([Category]?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/categories", headers: headers).responseArray(keyPath: "data") {(response: DataResponse<[Category]>) in
            let categories = response.result.value
            switch response.result {
                case .success:
                    if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                        completionHandler(categories)
                        if let nonNilArray = categories {
                            let realm = try! Realm()
                            try! realm.write {
                                realm.delete(realm.objects(Category.self))
                            }
                            for category in nonNilArray {
                                try! realm.write {
                                    realm.add(category)
                                }
                            }
                        }
                    } else {
                        completionHandler([])
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler([])
            }
        }
    }
    
    public func saveInvoice(invoice: Invoice, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let parameters: Parameters = convertToParameters(invoice)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseObject(keyPath: "data") { (response: DataResponse<Invoice>) in
            let addedInvoice = response.result.value
            switch response.result {
            case .success(let value):
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    if let addedInvoice = addedInvoice {
                       self.saveInvoices([addedInvoice])
                    }
                    completionHandler(true, nil)
                } else {
                    let json = JSON(value)
                    let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                    completionHandler(false, errors[0])
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    public func updateInvoice(invoice: Invoice, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let parameters: Parameters = convertToParameters(invoice)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(invoice.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    completionHandler(true, nil)
                } else {
                    let json = JSON(value)
                    let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                    completionHandler(false, errors[0])
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    public func deleteInvoice(invoice: Invoice, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(invoice.id)", method: .delete, headers: headers).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                        let realm = try! Realm()
                        let result = realm.object(ofType: Invoice.self, forPrimaryKey: invoice.id)
                        try! realm.write {
                            realm.delete(result!)
                        }
                        completionHandler(true, nil)
                    } else {
                        let json = JSON(value)
                        let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                        completionHandler(false, errors[0])
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    public func makePayment(value: Double, invoice: Invoice, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let parameters: Parameters = convertToParameters(invoice)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/payments/\(invoice.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let successResponse):
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    let realm = try! Realm()
                    try! realm.write {
                        invoice.payment = value
                    }
                    completionHandler(true, nil)
                } else {
                    let json = JSON(successResponse)
                    let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                    completionHandler(false, errors[0])
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    private func saveInvoices(_ invoices: [Invoice]) {
        let realm = try! Realm()
        for invoice in invoices {
            let invoiceRealm = realm.object(ofType: Invoice.self, forPrimaryKey: invoice.id)
            if invoiceRealm == nil {
                guard let category = invoice.category else {return}
                invoice.type = category.title
                invoice.categoryId = category.id
                try! realm.write {
                    realm.add(invoice)
                }
            } else {
                try! realm.write {
                    invoiceRealm?.title = invoice.title
                    invoiceRealm?.category = invoice.category
                    invoiceRealm?.categoryId = invoice.categoryId
                    invoiceRealm?.expireDate = invoice.expireDate
                    invoiceRealm?.lastExpireDate = invoice.lastExpireDate
                    invoiceRealm?.invoiceDescription = invoice.invoiceDescription
                    invoiceRealm?.isInstallment = invoice.isInstallment
                    invoiceRealm?.paid = invoice.paid
                    invoiceRealm?.totalPaid = invoice.totalPaid
                }
            }
        }
    }
    
    private func convertToParameters(_ invoice: Invoice) -> Parameters {
        return [
            "id": invoice.id,
            "title": invoice.title,
            "value": invoice.value,
            "expireDate": DateUtils.dateToString(invoice.expireDate),
            "totalPaid": invoice.totalPaid,
            "description": invoice.invoiceDescription,
            "type": invoice.type,
            "isInstallment": invoice.isInstallment,
            "payment": invoice.payment,
            "lastExpireDate": DateUtils.dateToString(invoice.lastExpireDate),
            "category": [
                "id": invoice.categoryId
            ]
        ]
    }
}
























