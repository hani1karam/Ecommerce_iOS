//
//  NetworkAPI.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
import Alamofire
struct NetworkingManager {
    static let shared: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
}

class NetworkApi{
    
    class func sendRequest<T: Decodable>( userImage: Data? = nil, method: HTTPMethod, url: String, parameters:[String:Any]? = nil, header: [String:String]?  = nil, completion: @escaping (_ error: Error?, _ response: T?)->Void) {
        NetworkingManager.shared.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .responseJSON { res -> Void in
                switch res.result
                {
                case .failure(let error):
                    completion(error,nil)
                case .success(_):
                    if (res.result.value as? Dictionary<String, Any>) != nil{
                        
                        do{
                            guard let data = res.data else { return }
                            let response = try JSONDecoder().decode(T.self, from: data)
                            completion(nil,response)
                        }catch let err{
                            print(err.localizedDescription)
                            print(err)
                            completion(err,nil)
                        }
                    }else{
                        completion(nil,nil)
                    }
                }
        }
        
    }
       class func AddToFav(userInfoDict : [String:Any] , completion:@escaping ( FavModel? ,  Error?) -> Void) {
    let headers = ["Content-Type" : "application/json"  ,"Authorization": "I5B5uuTH5ueaugdwIiETTnycnLUZ9M9iiVWZ0SSc8cTGNU2VlJZM2AF3ipJmbzLDBN77gv"]

           Alamofire.request("https://student.valuxapps.com/api/favorites", method: .post, parameters: userInfoDict as Parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                switch response.result {
               case .success :
                   do {
                       let responseModel = try JSONDecoder().decode(FavModel.self, from: response.data!)
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
