//
//  ContactVC.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/23/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ContactVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    static func instance () -> ContactVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
    }
    @IBOutlet weak var ContactTV: UITableView!
    var items = [ContactModelDatum]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ContactTV.delegate = self
        ContactTV.dataSource = self
loaspost()
        
    }
    

    func loaspost(){
        
        startLoading()
        NetworkApi.sendRequest(method: .get, url: "https://student.valuxapps.com/api/contacts",completion:
            
            {(err,response: ContactModel?) in
                self.stopLoading()
                if err == nil{
                    guard let data = response?.data.data else{return}
                    self.items = data.self
                    self.ContactTV.reloadData()
                    
                }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! ContacTableViewCell
        cell.name.text = items[indexPath.row].value
        cell.configure(compines: items[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }

    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
}
