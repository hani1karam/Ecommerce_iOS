//
//  DetailsTableViewCell.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var AddToCart: UIButton!
    @IBOutlet weak var NAme: UILabel!
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UI()
        
    }
    
    func UI() {
        View.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        View.layer.cornerRadius = 3.0
        View.layer.masksToBounds = false
        View.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        View.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        View.layer.shadowOpacity = 0.8
        
    }
    
}
extension UIImageView {
    func setImage(imageUrl: String){
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string:imageUrl), placeholder: nil, options: [.transition(.fade(0.7))],   completionHandler: nil)
    }
}
