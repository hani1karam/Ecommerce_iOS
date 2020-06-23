//
//  FirstCollectionViewCell.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import Kingfisher
class FirstCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ViewHome: UIView!
    @IBOutlet weak var AddToFav: UIButton!
    @IBOutlet weak var Dislike: UIButton!
    @IBOutlet weak var Dicont: UILabel!
    
    var checked = false

    override func awakeFromNib() {
        super.awakeFromNib()
        UI()
     }
 

    func UI() {
        ViewHome.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        ViewHome.layer.cornerRadius = 3.0
        ViewHome.layer.masksToBounds = false
        ViewHome.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        ViewHome.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        ViewHome.layer.shadowOpacity = 0.8
        
    }

    func configure(compines: Product) {
          
        if let img = URL(string: compines.image ?? ""){
                  DispatchQueue.main.async {

                          self.img.kf.setImage(with: img)
                             
                         }
               
          }
      }
    @IBAction func tick(sender: UIButton) {

        if checked {
            sender.setImage(UIImage(named:"love"), for: .normal)
            checked = false
        } else {
            sender.setImage(UIImage(named:"Love-1"), for: .normal)
            checked = true
        }
    }


 

     
    }

 
