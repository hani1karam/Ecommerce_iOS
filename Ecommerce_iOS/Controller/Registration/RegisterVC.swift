//
//  RegisterVC.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import Alamofire
import Photos
class RegisterVC: UIViewController {
    
    static func instance () -> RegisterVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
    }
    @IBOutlet weak var ViewHome: UIView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ButtonImage: UIButton!
    @IBOutlet weak var LblImage: UILabel!
    var localPath: String?
    let debuggingTag = "RegitserVC"

    override func viewDidLoad() {
        super.viewDidLoad()

        Setup()

    }
    

    func Setup(){
        ViewHome.backgroundColor = UIColor.white
      view.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        ViewHome.layer.cornerRadius = 3.0
        ViewHome.layer.masksToBounds = false
        ViewHome.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        ViewHome.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        ViewHome.layer.shadowOpacity = 0.8
    }

       @IBAction func SignUpButton(_ sender: Any) {
           if validData(){
               let urlReq = register
               guard  let data = imageView.image?.jpegData(compressionQuality: 0.2) else {return}
               let _: NSData = imageView.image!.pngData()! as NSData
               let imageobj = imageView.image!
               _ = imageobj.pngData()
               let params = [
                   "name": NameTextField.text ?? "",
                   "phone": PhoneTextField.text ?? "",
                   "email": EmailTextField.text ?? "",
                   "password": PasswordTextField.text ?? ""]
               self.startLoading()
               Alamofire.upload(multipartFormData: { multipartFormData in
                   multipartFormData.append(data, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                   for (key, value) in params {// this will loop the 'parameters' value, you can comment this if not needed
                       multipartFormData.append(value.data(using: .utf8)!, withName: key)
                       
                   }
               },
                                to:urlReq, method: .post)
               { (result) in
                   switch result {
                   case .success(let upload, _, _):
                       upload.uploadProgress(closure: { (progress) in
                           print("Upload Progress: \(progress.fractionCompleted)")
                       })
                       upload.responseJSON { response in
                           switch response.result {
                           case .success :
                               do {
                                   let responseModel = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
                                   // completion(responseModel, nil)
                                   self.showMsg(msg: responseModel.message ?? "")
                                   self.stopLoading()
    
                             let Home = MainTabBar.instance()
                                   Home.modalPresentationStyle = .fullScreen
                                   self.present(Home, animated: true, completion: nil)
 

                               } catch (let error) {
                                   print(error.localizedDescription)
                                   //   completion(nil , error)
                               }
                           case .failure(let error) :
                               print(error.localizedDescription)
                               //completion(nil , error)
                               self.showMsg(msg: "هناك مشكله ما راجع البيانات كامله")
                               self.stopLoading()
                               
                           }
                           // completion("success")
                           print(response)
                       }
                   case .failure(let encodingError):
                       self.showMsg(msg: "هناك مشكله ما راجع البيانات كامله")
                       self.stopLoading()
                       
                       print(encodingError)
                       //  completion("failed")
                   }
               }
           }
       }
       func validData() -> Bool {
           
           if (localPath?.isEmpty) ?? true{
               self.showMsg(msg: " plz enter image ")
               return false
           }
           if NameTextField.text!.isEmpty {
               self.showMsg(msg: "plz enter name ")
               return false
           }
           
           if PhoneTextField.text!.isEmpty {
               self.showMsg(msg: "plz enter phone ")
               return false
           }
           
           if EmailTextField.text!.isEmpty {
               self.showMsg(msg: "plz enter Email ")
               return false
           }
           
           if PasswordTextField.text!.isEmpty {
               self.showMsg(msg: "plz enter password ")
               return false
           }
           
           return true
       }
       
       @IBAction func addbutton(_ sender: UIButton) {
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               PHPhotoLibrary.requestAuthorization { (status) in
                   DispatchQueue.main.async {
                       
                       switch status {
                       case .authorized:
                           let myPickercontroller = UIImagePickerController()
                           myPickercontroller.delegate = self
                           myPickercontroller.sourceType = .photoLibrary
                           self.present(myPickercontroller, animated: true)
                           
                       case .notDetermined:
                           if status == PHAuthorizationStatus.authorized {
                               let myPickercontroller = UIImagePickerController()
                               myPickercontroller.delegate = self
                               myPickercontroller.sourceType = .photoLibrary
                               
                               self.present(myPickercontroller, animated: true)
                           }
                           
                       case .restricted:
                           let alert = UIAlertController(title: "photo Libarary Restricted ", message: "photo libarary access restricted ", preferredStyle: .alert)
                           let okaction = UIAlertAction(title: "ok", style: .default)
                           alert.addAction(okaction)
                           self.present(alert, animated: true)
                           
                       case .denied:
                           let alert = UIAlertController(title: "photo Libarary denied ", message: "photo libarary access denied ", preferredStyle: .alert)
                           let okaction = UIAlertAction(title: "go to setting", style: .default) {
                               (action) in
                               
                               DispatchQueue.main.async {
                                   let url = URL(string: UIApplication.openSettingsURLString)!
                                   UIApplication.shared.open(url, options: [:])
                                   
                               }
                           }
                           
                           let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
                           alert.addAction(okaction)
                           alert.addAction(cancelAction)
                           
                           self.present(alert, animated: true)
                           
                       @unknown default:
                           fatalError()
                       }
                   }
               }
               
           }
           
           
       }
       
       @IBAction func BackToLoginHome(_ sender: Any) {
      dismiss(animated: true, completion: nil)
       }
       


}
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let imageName = "temp"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        print(debuggingTag, "image path : \(imagePath)")
        
        
        
        
        localPath = imagePath
        print(debuggingTag, "local path: \(String(describing: localPath))")
        
        if let image = info[.editedImage] as? UIImage {
            self.imageView.image = image
            self.imageView.image = image
            ButtonImage.isHidden = true
 
            
            if let data = image.jpegData(compressionQuality: 80)
            {
                do {
                    try data.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
                } catch let error {
                    print(error)
                }
            }
            
            
        } else if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
            
            if let data = image.jpegData(compressionQuality: 80)
            {
                do {
                    try data.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
                } catch let error {
                    print(error)
                }
            }
            
            
        }
        
        ButtonImage.isHidden = true
 
        
        
        dismiss(animated: true)
    }
    
    func imGWPickerControllerDidCancek(_ picker: UIImagePickerController)
    {
        dismiss(animated: true)
        ButtonImage.isHidden = true
     }
    
}



