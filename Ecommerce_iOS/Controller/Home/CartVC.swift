//
//  CartVC.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/23/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import Alamofire

class CartVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    static func instance () -> CartVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
    }
    
    var items  = [CartItem]()
    var index = 0
    @IBOutlet weak var CartTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CartTV.delegate = self
        CartTV.dataSource = self
        loadcart()
        self.CartTV.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CartTableViewCell
        cell.name.text = items[indexPath.row].product.name
        cell.img.setImage(imageUrl: items[indexPath.row].product.image ?? "")
        return cell
    }
    func loadcart(){
        let headers = ["Authorization": "I5B5uuTH5ueaugdwIiETTnycnLUZ9M9iiVWZ0SSc8cTGNU2VlJZM2AF3ipJmbzLDBN77gv"]
        
        startLoading()
        NetworkApi.sendRequest(method: .get, url: carts,header:headers, completion:
            
            {(err,response: ShowCart?) in
                self.stopLoading()
                if err == nil{
                    
                    guard let data = response?.data.cartItems else{return}
                    self.items = data.self
                    self.CartTV.reloadData()
                    
                    
                }
        })
    }
    
    

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 164
}

}
