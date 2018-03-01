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
    
    public static var shared: InvoiceAPI = {
        let invoiceAPI = InvoiceAPI()
        return invoiceAPI
    }()
    
    private init() {
        
    }
    
    public func getInvoices(accessToken: String, params: [String]?, completionHandler: @escaping([Invoice]?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", headers: headers).responseArray(keyPath: "data.content") {(response: DataResponse<[Invoice]>) in
            let invoices = response.result.value
            switch response.result {
            case .success:
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    completionHandler(invoices)
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
                        self.defaults.set(true, forKey: "loadedFromAPI")
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
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
    
    public func updateInvoice(invoice: Invoice, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let parameters: Parameters = convertToParameters(invoice)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(invoice.id!)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(invoice.id!)", method: .delete, headers: headers).responseJSON { (response) in
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
    
    public func makePayment(value: Double, invoice: Invoice, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        invoice.payment = value
        let parameters: Parameters = convertToParameters(invoice)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/payments/\(invoice.id!)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
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
    
    private func convertToParameters(_ invoice: Invoice) -> Parameters {
        var parameters: Parameters = [
            "id": "",
            "title": invoice.title!,
            "value": invoice.value!,
            "expireDate": DateUtils.dateToString(invoice.expireDate!, with: "yyyy-MM-dd HH:mm:ss"),
            "totalPaid": invoice.totalPaid!,
            "description": invoice.description!,
            "type": invoice.type!.rawValue.uppercased().replacingOccurrences(of: " ", with: "_"),
            "isInstallment": invoice.isInstallment!,
            "payment": "",
            "lastExpireDate": invoice.lastExpireDate != nil ? DateUtils.dateToString(invoice.lastExpireDate!, with: "yyyy-MM-dd HH:mm:ss") : ""
        ]
        if let id = invoice.id {
           parameters["id"] = id
        }
        if let payment = invoice.payment {
            parameters["payment"] = payment
        }
        return parameters
    }
}
























