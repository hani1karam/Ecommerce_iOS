//
//  DetailsVC.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import Kingfisher
class DetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    static func instance () -> DetailsVC {
         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
         return storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
     }
    var items = [Product]()

    @IBOutlet weak var HomeTV: UITableView!
    @IBOutlet weak var HomeCV: UICollectionView!
    
    var delegate: DelegateItemSelected?
     var product:Product?
      var item:Datum?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HomeTV.delegate = self
        HomeTV.dataSource = self
        HomeCV.delegate  = self
        HomeCV.dataSource = self
        
        loaspost()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailsTableViewCell
        cell.NAme.text = delegate?.name
        cell.Img.setImage(imageUrl: (delegate?.image!)!)
        cell.AddToCart.tag = indexPath.row
        cell.AddToCart.addTarget(self, action: #selector(subscribe(_:)), for: .touchUpInside)
         return cell
     }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 483
    }
        @objc func subscribe(_ sender: UIButton){
            guard let id = delegate?.id else {return}
             let paramters = [
                "product_id": id
             ]
            let headers = ["Authorization": "I5B5uuTH5ueaugdwIiETTnycnLUZ9M9iiVWZ0SSc8cTGNU2VlJZM2AF3ipJmbzLDBN77gv"]

             self.startLoading()
            NetworkApi.sendRequest(method: .post, url: carts,parameters:paramters,header: headers) { (err, response:AddToCart?) in
                self.stopLoading()
                if err == nil {
                    guard let data = response?.status else {return}
                    if data == true{
                        self.showMsg(msg: response?.message ?? "")
                        self.HomeTV.reloadData()

                         print(response)
                    }
                    else {
                        self.showMsg(msg: response?.message ?? "")
                        self.HomeTV.reloadData()
                        print(response)

                    }
                }
            }



    }
    func loaspost(){
        let headers = ["Authorization": "I5B5uuTH5ueaugdwIiETTnycnLUZ9M9iiVWZ0SSc8cTGNU2VlJZM2AF3ipJmbzLDBN77gv"]
        
        startLoading()
        NetworkApi.sendRequest(method: .get, url: home,header:headers,completion:
            
            {(err,response: HomeModel?) in
                self.stopLoading()
                if err == nil{
                    guard let data = response?.data else{return}
                    self.items = data.products
                    self.HomeCV.reloadData()
                    
                }
        })
    }

    @IBAction func Back(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
}
extension DetailsVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FirstCollectionViewCell
              cell.name.text = items[indexPath.row].name
              cell.configure(compines: items[indexPath.row])
              let price = Int(items[indexPath.row].price)
              cell.price.text = "السعر: \(price)"
              cell.AddToFav.tag = indexPath.row
              cell.AddToFav.addTarget(self, action: #selector(subscribe(_:)), for: .touchUpInside)
              cell.Dislike.tag = indexPath.row
              cell.Dislike.addTarget(self, action: #selector(subscribe(_:)), for: .touchUpInside)
              let discont =  Int(  items[indexPath.row].oldPrice - items[indexPath.row].price  ) / Int(items[indexPath.row].oldPrice) * 100
              cell.Dicont.text = "%\(discont)"

        return cell
    }
    
    
}
