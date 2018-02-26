//
//  LoginAPI.swift
//  FinanceAPP
//
//  Created by Victor Prado on 24/02/18.
//  Copyright © 2018 Victor Prado. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class LoginAPI {
    
    public static let shared: LoginAPI = {
        let loginApi = LoginAPI()
        return loginApi
    }()
    
    private let endpoint: String = "/auth"
    private var defaults = UserDefaults.standard
    
    private init() {
        
    }
    
    public func authenticate(email: String, password: String, completionHandler: @escaping (String) -> Void) {
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        Alamofire.request("\(RestConfig.basePath)\(endpoint)", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if response.response!.statusCode >= 200 && response.response!.statusCode <= 300 {
                        let json = JSON(value)
                        let accessToken = json["data"]["token"]
                        self.defaults.set(accessToken.rawString(), forKey: "accessToken")
                        completionHandler("ok")
                    } else {
                        completionHandler("Something went wrong")
                }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(error.localizedDescription)
            }
        }
    }
}
