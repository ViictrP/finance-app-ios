//
//  UserAPI.swift
//  FinanceAPP
//
//  Created by Victor Prado on 02/03/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import RealmSwift

public class UserAPI {
    
    public static let shared: UserAPI = {
        let userAPI = UserAPI()
        return userAPI
    }()
    
    private let endpoint: String = "/users"
    private var defaults = UserDefaults.standard
    
    private init() {
        
    }
    
    public func register(user: User, completionHandler: @escaping(Bool, String?) -> Void) {
        let parameters: Parameters = buildParameters(user)
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    
    public func getInfo(completionHandler: @escaping(Bool, String?) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(defaults.string(forKey: "accessToken")!)"]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)/self", headers: headers).responseObject(keyPath: "data") { (response: DataResponse<User>) in
            let user = response.result.value
            switch response.result {
                case .success:
                    if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                        completionHandler(true, nil)
                        if let user = user {
                            let realm = try! Realm()
                            try! realm.write {
                                realm.add(user)
                                do {
                                    try realm.commitWrite()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } else {
                        completionHandler(false, nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, error.localizedDescription)
            }
        }
    }
    
    private func buildParameters(_ user: User) -> Parameters{
        return [
            "name": user.name,
            "email": user.email,
            "password": user.password!
        ]
    }
}
