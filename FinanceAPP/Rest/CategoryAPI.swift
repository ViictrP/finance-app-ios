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
                    let realm = try! Realm()
                    if let categories = categories {
                        for category in categories {
                            let categoryRealm = realm.object(ofType: Category.self, forPrimaryKey: category.id)
                            if categoryRealm == nil {
                                try! realm.write {
                                    realm.add(category)
                                }
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
}
