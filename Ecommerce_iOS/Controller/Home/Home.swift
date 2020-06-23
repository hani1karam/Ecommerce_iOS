//
//  HomeVC.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//
protocol DelegateItemSelected {
    var name: String? {get set}
    var image: String? {get set}
    var id:Int? {get set}
}
import UIKit
 
class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,DelegateItemSelected{
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var pagecontroller: UIPageControl!
    @IBOutlet weak var HomeCV: UICollectionView!
    @IBOutlet weak var OtherCV: UICollectionView!
    
    var imgarray = [
        "https://student.valuxapps.com/storage/uploads/banners/1592799178qBAAg.1.png",
        "https://student.valuxapps.com/storage/uploads/banners/1592799281zX2fu.3.png"]
    var timer = Timer()
    var counter = 0
    var name: String?
    var image: String?
    var index = 0
    var id: Int?
    var items = [Product]()
    var item = [Datum]()



    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        HomeCV.delegate = self
        HomeCV.dataSource = self
        OtherCV.delegate = self
        OtherCV.dataSource = self
        pagecontroller.numberOfPages = imgarray.count
        pagecontroller.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            
        }
        loaspost()
        loadother()
    }
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let Deatils = segue.destination as! DetailsVC
       
            Deatils.delegate = self
           Deatils.delegate?.name = items[index].name
           Deatils.delegate?.image = items[index].image
           Deatils.delegate?.id = items[index].id
       
    }

    
    @objc func changeImage() {
        
        if counter < imgarray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pagecontroller.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collection.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pagecontroller.currentPage = counter
            counter = 1
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection{
        return imgarray.count
        }
        else if collectionView == HomeCV {
            return items.count
        }
        else {
            return item.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collection{
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.loadImageUsingCache(withUrl: "\(imgarray[indexPath.row])")
            
        }
        return cell
        }
        else if collectionView == HomeCV{
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
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! CollectionViewCell
            cell.name.text = item[indexPath.row].name
            cell.configure(compines: item[indexPath.row])
            let price = Int(item[indexPath.row].price)
            cell.price.text = "السعر: \(price)"
            cell.AddToFav.tag = indexPath.row
            cell.AddToFav.addTarget(self, action: #selector(subscribe(_:)), for: .touchUpInside)
            cell.Dislike.tag = indexPath.row
            cell.Dislike.addTarget(self, action: #selector(subscribe(_:)), for: .touchUpInside)

            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         
        index = indexPath.row
        performSegue(withIdentifier: "Home", sender: self)

    }
        @objc func subscribe(_ sender: UIButton){
             let param = [
                "product_id": items[sender.tag].id
            ]
             self.startLoading()
            NetworkApi.AddToFav(userInfoDict: param) { (response, err) in
                self.stopLoading()
                if response?.status == true{
                  
                    self.showMsg(msg: response?.message ?? "")
                    print(response)
                    
                }
                else{
                    self.showMsg(msg: response?.message ?? "")

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
    func loadother(){
        let headers = ["Authorization": "I5B5uuTH5ueaugdwIiETTnycnLUZ9M9iiVWZ0SSc8cTGNU2VlJZM2AF3ipJmbzLDBN77gv"]
        
        startLoading()
        NetworkApi.sendRequest(method: .get, url: "https://student.valuxapps.com/api/products?category_id=2",header:headers,completion:
            
            {(err,response: SecondHomeModel?) in
                self.stopLoading()
                if err == nil{
                    guard let data = response?.data?.data else{return}
                    self.item = data.self
                    self.OtherCV.reloadData()
                    
                }
        })
    }

    
}
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
    
    
}
