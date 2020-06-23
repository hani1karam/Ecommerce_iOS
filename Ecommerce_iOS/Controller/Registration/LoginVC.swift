//
//  ViewController.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var SignInButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Setup()
        
    }
    func Setup(){
        HomeView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        HomeView.layer.cornerRadius = 3.0
        HomeView.layer.masksToBounds = false
        HomeView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        HomeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        HomeView.layer.shadowOpacity = 0.8
        
        SignInButton.layer.borderColor = #colorLiteral(red: 0.1128181443, green: 0.6548296213, blue: 0.3638802171, alpha: 1)
        SignInButton.layer.cornerRadius = 5
        SignInButton.layer.cornerRadius = 30
        SignInButton.layer.borderWidth = 6

    }

    @IBAction func SignInBotton(_ sender: Any) {
               if validData(){
               let param = ["email":EmailTextField.text ?? "" ,
                            "password":PasswordTextField.text ?? ""]
               startLoading()
               NetworkMagarForRegstration.loginUser(userInfoDict: param) { [unowned self] (user, error) in
                   
                   if error  == nil{
                    guard let status = user?.status else {return}
                       if status {
                           self.showMsg(msg: user?.message ?? "")
                           self.stopLoading()
        
                         let Home = MainTabBar.instance()
                           Home.modalPresentationStyle = .fullScreen
                           self.present(Home, animated: true, completion: nil) 
                       }
                       else {
                           self.showMsg(msg: user?.message ?? "")
                           self.stopLoading()
                           print("OK")
                           
                       }
                       
                   }
                   
               }
               
           }

    }
    func validData() -> Bool{
        
        if EmailTextField.text!.isEmpty && PasswordTextField.text!.isEmpty{
            self.showMsg(msg: "plz enter data")
            return false
        }
        
        if EmailTextField.text!.isEmpty{
            self.showMsg(msg: "plz eneter Email")
            return false
        }
        
        if PasswordTextField.text!.isEmpty{
            self.showMsg(msg: "plz enter password")
            return false
        }
        
        return true
    }

       @IBAction func RegisterHome(_ sender: Any) {
           let Register = RegisterVC.instance()
           Register.modalPresentationStyle = .fullScreen
           self.present(Register, animated: true, completion: nil)

       }
       

}

