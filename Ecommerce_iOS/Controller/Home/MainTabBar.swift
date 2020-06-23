//
//  MainTabBar.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    static func instance () -> MainTabBar {
         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
         return storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBar
     }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
