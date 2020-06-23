//
//  NetworkManagerForUser.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
import Alamofire
class NetworkMagarForRegstration{
    class func loginUser (userInfoDict : [String:Any] , completion:@escaping ( LoginModel? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        
        Alamofire.request(login, method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value!)
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(LoginModel.self, from: response.data!)
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
        
    }
 
      

}
 
 
