//
//  HomeCollectionViewCell.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Setup()
    }
    func Setup(){
        img.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        img.layer.cornerRadius = 3.0
        img.layer.masksToBounds = false
        img.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        img.layer.shadowOffset = CGSize(width: 0, height: 0)
        img.layer.shadowOpacity = 0.8
    }
}
