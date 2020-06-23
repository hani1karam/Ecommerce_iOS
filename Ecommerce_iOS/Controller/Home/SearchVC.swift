//
//  SearchVC.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/23/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class SearchVC: UIViewController{
 
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchResultArray = [SearchModelDatum]()
        var searchedCountry = [String]()
        var searching = false
    
    var dataArray = [String]()

    var filteredArray = [String]()

    var shouldShowSearchResults = false
         override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
 //   searchBarSearchButtonClicked(searchBar)
            if let textFieldInsideSearchBar  = searchBar.value(forKey: "searchField") as? UITextField{
                textFieldInsideSearchBar.font = textFieldInsideSearchBar.font?.withSize(13)
                if let textField = textFieldInsideSearchBar.subviews.first{
                    textField.backgroundColor = .white
                    textField.layer.cornerRadius = 6
                    textField.clipsToBounds = true
                }
            }
             if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textAlignment = .right
                textfield.textColor = UIColor(red: 55/255, green: 97/255, blue: 116/255, alpha: 1)
            }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let keywords = searchBar.text else { return }
            search(keyword: keywords)
            self.view.endEditing(true)
        }
        
        func search(keyword: String) {
            self.startLoading()
            let headers = ["Authorization": "I5B5uuTH5ueaugdwIiETTnycnLUZ9M9iiVWZ0SSc8cTGNU2VlJZM2AF3ipJmbzLDBN77gv"]

            NetworkApi.sendRequest( method: .post, url: "https://student.valuxapps.com/api/products/search",parameters: ["text": keyword],header:headers ,completion: { (err, response: SearchModel?) in
                self.stopLoading()
                if err == nil{
                    if response!.status{
                        guard let result = response?.data.data else{return}
                        self.searchResultArray = result
                        self.tableView.reloadData()
                        print(err)
                        print(response)
                    }
                }
            })
        }
        
       
    }

    extension SearchVC: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResultArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchProductCell
            cell.name.text = searchResultArray[indexPath.row].name
            cell.img.setImage(imageUrl: searchResultArray[indexPath.row].image ?? "")
             return cell
        }
        
 
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 153
        }
    }
extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
 
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBarSearchButtonClicked(searchBar)
        tableView.reloadData()
    }
    
}
