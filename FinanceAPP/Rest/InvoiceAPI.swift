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
                        completionHandler(categories)
                    } else {
                        completionHandler([])
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler([])
            }
        }
    }
    
    public func saveInvoice(invoice: Invoice, completionHandler: @escaping(Bool) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let parameters: Parameters = convertToParameters(invoice)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
        }
    }
    
    private func convertToParameters(_ invoice: Invoice) -> Parameters {
        return [
            "title": invoice.title!,
            "value": invoice.value!,
            "expireDate": DateUtils.dateToString(invoice.expireDate!, with: "yyyy-MM-dd HH:mm:ss"),
            "totalPaid": invoice.totalPaid!,
            "description": invoice.description!,
            "type": invoice.type!.rawValue.uppercased().replacingOccurrences(of: " ", with: "_"),
            "isInstallment": invoice.isInstallment!
        ]
    }
}
























