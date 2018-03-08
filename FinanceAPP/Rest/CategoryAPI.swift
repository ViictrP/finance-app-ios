//
//  CategoryAPI.swift
//  FinanceAPP
//
//  Created by Victor Prado on 06/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import RealmSwift

public class CategoryAPI {
    
    private let endpoint: String = "/categories"
    private var defaults = UserDefaults.standard
    
    public static var shared: CategoryAPI = {
        let categoryAPI = CategoryAPI()
        return categoryAPI
    }()
    
    private init() {
        
    }
    
    public func getCategories(completionHandler: @escaping([Category]?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .get, headers: headers).responseArray(keyPath: "data") {(response: DataResponse<[Category]>) in
            let categories = response.result.value
            switch response.result {
            case .success:
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    completionHandler(categories)
                    if let categories = categories {
                        self.saveCategories(categories)
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
    
    public func getCategoryInfo(_ category: Category, completionHandler: @escaping(Category?, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(category.id)", method: .get, headers: headers).responseObject(keyPath: "data") { (response: DataResponse<Category>) in
            let category = response.result.value
            switch response.result {
            case .success(let value):
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    if let category = category {
                        self.saveCategories([category])
                    }
                    completionHandler(category, nil)
                } else {
                    let json = JSON(value)
                    let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                    completionHandler(nil, errors[0])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func saveCategory(_ category: Category, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let params: Parameters = buildParams(category)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseObject(keyPath: "data") { (response: DataResponse<Category>) in
            let category = response.result.value
            switch response.result {
                case .success(let value):
                    if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                        if let category = category {
                            self.saveCategories([category])
                        }
                        completionHandler(true, nil)
                    } else {
                        let json = JSON(value)
                        let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                        completionHandler(false, errors[0])
                }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    public func updateCategory(_ category: Category, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        let params: Parameters = buildParams(category)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(category.id)", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseObject(keyPath: "data") { (response: DataResponse<Category>) in
            let category = response.result.value
            switch response.result {
            case .success(let value):
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    if let category = category {
                        self.saveCategories([category])
                    }
                    completionHandler(true, nil)
                } else {
                    let json = JSON(value)
                    let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                    completionHandler(false, errors[0])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func deleteCategory(_ category: Category, completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/\(category.id)", method: .delete, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                    let realm = try! Realm()
                    try! realm.write {
                        let result = realm.objects(Invoice.self)
                        let invoices = Array(result)
                        for invoice in invoices {
                            if invoice.categoryId == category.id {
                                realm.delete(invoice)
                                break;
                            }
                        }
                        realm.delete(category)
                    }
                    completionHandler(true, nil)
                } else {
                    let json = JSON(value)
                    let errors: [String] = json["errors"].rawValue as? [String] ?? ["An error occurred"]
                    completionHandler(false, errors[0])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func buildParams(_ category: Category) -> Parameters {
        return [
            "title": category.title
        ]
    }
    
    fileprivate func saveCategories(_ categories: [Category]) {
        let realm = try! Realm()
        for category in categories {
            let categoryRealm = realm.object(ofType: Category.self, forPrimaryKey: category.id)
            if categoryRealm == nil {
                try! realm.write {
                    realm.add(category)
                }
            } else {
                try! realm.write {
                    categoryRealm?.title = category.title
                    categoryRealm?.invoicesCount = category.invoicesCount
                    categoryRealm?.updateDate = category.updateDate
                }
            }
        }
    }
}
