//
//  Alert.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
import UIKit
import Photos
 
class UIManager{
    
    static let shared = UIManager()
    
    enum FollowState { case following ; case followers }
    enum controlView { case show      ; case hide}
    enum ediType     { case pic       ; case cover}
    
    var followMe      = "تابعني"
    var followDone    = "تمت المتابعة"
    
    var appColor:UIColor{ return UIColor(red: 79.0/255.0, green: 165.0/255.0, blue: 100.0/255.0, alpha: 1)}
    var myHeight:CGFloat{ return ceil (UIScreen.main.bounds.height)}
    var myWidth:CGFloat { return ceil (UIScreen.main.bounds.width)}
    
    var editingType:ediType = .pic
    var newCover:UIImage!
    var newImg:UIImage!
    var imageToEdit : UIImage!
    let loadingView = LoadingView()
    let myAlert     = MyAlert()
    let darkView    = DarKView()
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    func updatelFollowButton(For FollowButton:UIButton, toggle:Bool){
        
        var title    = ""
        var newtitle = ""
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                let currentTitle = FollowButton.title(for: .normal) ?? ""
                newtitle = currentTitle == self.followDone ? self.followMe:self.followDone
                title    = toggle ? newtitle : currentTitle
                
                FollowButton.setTitle(title, for: .normal)
                FollowButton.titleLabel?.adjustsFontSizeToFitWidth = true
                FollowButton.titleLabel?.minimumScaleFactor       = 0.5
                
                if title == UIManager.shared.followMe{
                    FollowButton.setTitleColor(self.appColor, for: .normal)
                    FollowButton.backgroundColor   = .white
                    FollowButton.layer.borderWidth = 2.0
                    FollowButton.layer.borderColor = self.appColor.cgColor
                }
                else if title == self.followDone{
                    FollowButton.setTitleColor(.white, for: .normal)
                    FollowButton.backgroundColor   = self.appColor
                    FollowButton.layer.borderWidth = 2.0
                    FollowButton.layer.borderColor = self.appColor.cgColor
                }
                else if title == "k" {
                    FollowButton.setTitleColor(.white, for: .normal)
                    FollowButton.backgroundColor = .white
                    FollowButton.layer.borderWidth = 0.0
                    FollowButton.layer.borderColor = UIColor.white.cgColor
                }
            })
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
}



extension UIViewController{
    //MARK:- 1- Navigation To
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func navTo(VCName:String, storyBoardName:String?=nil){
        
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: VCName) else { return}
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
        }
    }
    
    
    func segueTo(segueID:String){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.performSegue(withIdentifier: segueID, sender: self)
            })
        }
    }
    
    //MARK:- 2- Photos
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func checkPhotoLibraryPermission() {
        let photosPermission = PHPhotoLibrary.authorizationStatus()
        if photosPermission == .notDetermined || photosPermission == .restricted {
            PHPhotoLibrary.requestAuthorization({status in
                guard status == .authorized else { return }
                self.presentImagePicker()
            })
        }
        else if photosPermission == .authorized {
            self.presentImagePicker()
        }
    }
    
    
    func presentImagePicker(){
        let imagePicker           = UIImagePickerController()
        imagePicker.delegate      = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType    = .photoLibrary
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.present(imagePicker,animated: true,completion: nil)
            })
        }
    }
    
    //MARK:- 3- Hanlde Loading
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func startLoading(){
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            self.view.addSubview(UIManager.shared.loadingView)
        }
    }
    
    
    func stopLoading(msg:String?=nil){
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            UIManager.shared.loadingView.removeFromSuperview()
            guard msg != nil else { return }
            self.showMsg(msg: msg!)
        }
    }
    
    func showMsg(msg:String, goBack:Bool?=nil){
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            self.view.addSubview(UIManager.shared.darkView)
            self.view.addSubview(UIManager.shared.myAlert)
            UIManager.shared.myAlert.setLayout(centerX: self.view.centerXAnchor,
                                               centerY: self.view.centerYAnchor,
                                               width:   ceil(UIScreen.main.bounds.width  * 0.8),
                                               height:  ceil(UIScreen.main.bounds.height * 0.25))
            UIManager.shared.myAlert.setupMe(myText: msg, goBack: goBack)
        }
    }
    
    //MARK:- 4- Check Empty Fileds
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func checkFileds(fileds:[UITextField]) -> Bool{
        let emptyFileds = fileds.filter {$0.text == ""}
        if emptyFileds.count != 0 {
            DispatchQueue.main.async {
                UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
                self.showMsg(msg: "لقد تركت احد الحقول فارغة")
            }
        }
        return emptyFileds.count == 0 ? true : false
    }
    
    
    //MARK:- To hide Keyboard by tapping Screen
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //    func hideKeyboardWhenTappedAround() {
    //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    //        tap.cancelsTouchesInView = false
    //        view.addGestureRecognizer(tap)
    //    }
    //
    //
    //    @objc func dismissKeyboard() {
    //        DispatchQueue.main.async {
    //            self.view.endEditing(true)
    //        }
    //    }
    
    
}

 
    //MARK:- To hide Keyboard by tapping Screen
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //    func hideKeyboardWhenTappedAround() {
    //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    //        tap.cancelsTouchesInView = false
    //        view.addGestureRecognizer(tap)
    //    }
    //
    //
    //    @objc func dismissKeyboard() {
    //        DispatchQueue.main.async {
    //            self.view.endEditing(true)
    //        }
    //    }
    
    
 class LoadingView: RoundedView {
     
     let successIcon        = UIImageView()
     let activityIndicator  = UIActivityIndicatorView()
     var viewWidth:CGFloat  {return UIScreen.main.bounds.width  * 0.5}
     var viewHeight:CGFloat {return UIScreen.main.bounds.height * 0.1}
     
     
     override func didMoveToSuperview() {
         super.didMoveToSuperview()
         if let _ = self.superview {
             setupView()
             setupActivityIndicator()
         }
     }
     
     
     func setupView(){
         self.setLayout(centerX: superview!.centerXAnchor,
                        centerY: superview!.centerYAnchor,
                        width:   viewHeight,
                        height:  viewHeight)
         self.backgroundColor =  UIColor(red: 79.0/255.0, green: 165.0/255.0, blue: 100.0/255.0, alpha: 1)
     }
     
     
     func setupActivityIndicator(){
         self.addSubview(activityIndicator)
         activityIndicator.setLayout(centerX: self.centerXAnchor,
                                     centerY: self.centerYAnchor,
                                     width:   viewHeight/2,
                                     height:  viewHeight/2)
         activityIndicator.transform        = CGAffineTransform(scaleX: 1.2, y: 1.2)
         activityIndicator.style = .whiteLarge
         activityIndicator.hidesWhenStopped = true
         activityIndicator.startAnimating()
     }
     
 }


@IBDesignable class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius  = 10
    }
}


@IBDesignable class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds      = true
        self.layer.cornerRadius = self.bounds.size.height/2.0
    }
}


//MARK: 2- Button Classes
@IBDesignable class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius  = layer.frame.size.height*0.149
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor        = 0.5
    }
}


@IBDesignable class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius  = layer.frame.size.height/2
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor        = 0.5
        
    }
}



class ButtonWithText:UIButton{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor        = 0.5
    }
}





//MARK: 3- View Classes
@IBDesignable class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius  = 10
    }
}


@IBDesignable class CircularView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds      = true
        self.layer.cornerRadius = self.bounds.size.height/2.0
    }
}


@IBDesignable class CardView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius  = 10
        layer.shadowColor   = UIColor.gray.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius  = 12.0
        layer.shadowOpacity = 0.7
    }
}




//MARK: 4- UILabel Classes

class RoundedLabel:UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius  = 10
        layer.masksToBounds = true
    }
}



class RoundedTextView:UITextView{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius  = 10
        layer.masksToBounds = true
    }
}


class RoundedTableView:UITableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius  = 10
        layer.masksToBounds = true
    }
}


class MyAlert : RoundedView {
    
    let myLable  = UILabel()
    let myButton = RoundedButton ()
    var goBack:Bool!
    
    var myHeight : CGFloat { return ceil(UIScreen.main.bounds.height * 0.25) }
    var myWidth  : CGFloat { return ceil(UIScreen.main.bounds.width  * 0.8) }
    
    
    func setupMe(myText:String, goBack:Bool?=nil){
        
        self.backgroundColor = UIManager.shared.appColor
        
        [myLable, myButton].forEach { self.addSubview($0) }
        myLable.setLayout(top:      self.topAnchor, paddingTop: 5,
                          leading:  self.leadingAnchor, paddingLeading: 5,
                          trailing: self.trailingAnchor, paddingTrailing: 5,
                          height:   ceil(self.myHeight * 0.65))
        
        myLable.text = myText
        myLable.backgroundColor = .clear
        myLable.textColor       = .white
        myLable.font            = UIFont(name: "Cairo", size: 17)
        myLable.textAlignment   = .center
        myLable.lineBreakMode   = .byWordWrapping
        myLable.numberOfLines   = 0
        myLable.adjustsFontSizeToFitWidth = true
        
        
        myButton.setLayout(top:     self.myLable.bottomAnchor, paddingTop: 15,
                           bottom:  self.bottomAnchor, paddingBottom: 10,
                           centerX: self.centerXAnchor,
                           width:   ceil(self.myWidth*0.7))
        
        
        myButton.backgroundColor = .white
        myButton.setTitleColor(UIManager.shared.appColor, for: .normal)
        myButton.setTitle("حسنا", for: .normal)
        myButton.titleLabel?.font = UIFont(name: "Cairo-Bold", size: 20)
        myButton.isEnabled = true
        
        if goBack == true {
            myButton.addTarget(self, action: #selector(self.doneTapped2(sender:)), for: .touchUpInside)
        }
        else{
            myButton.addTarget(self, action: #selector(self.doneTapped(sender:)), for: .touchUpInside)
        }
        
    }
    
    
    @objc func doneTapped(sender: AnyObject){
        DispatchQueue.main.async {
            UIView.transition(with: self.parentVC!.view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            UIManager.shared.darkView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    
    @objc func doneTapped2(sender: AnyObject){
        DispatchQueue.main.async {
            UIView.transition(with: self.parentVC!.view, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            self.parentVC?.navigationController?.popViewController(animated: false)
            UIManager.shared.darkView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
    }
    
    
}
 
class DarKView : UIView {
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.setLayout(top:      superview?.topAnchor,
                       leading:  superview?.leadingAnchor,
                       trailing: superview?.trailingAnchor,
                       bottom:   superview?.bottomAnchor)
    }
    
    
    
}
extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        let str = attributedString.string.replacingOccurrences(of: "  ", with: "", options: .regularExpression, range: nil)
        return str.replacingOccurrences(of: "\n\n", with: "", options: .regularExpression, range: nil)
    }
}


extension UIView {
    // Create image snapshot of view.
    func snapshot(of rect: CGRect? = nil) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}

extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
        pinchGesture.scale = 1
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}



extension UIView {
    var parentVC: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}



extension UIView{
    //to AutoLAyout UIKit items Programmatically
    func setLayout( top:      NSLayoutYAxisAnchor? = nil, paddingTop:     CGFloat?  = 0,
                    leading:  NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat?  = 0,
                    trailing: NSLayoutXAxisAnchor? = nil, paddingTrailing:CGFloat?  = 0,
                    bottom:   NSLayoutYAxisAnchor? = nil, paddingBottom:  CGFloat?  = 0,
                    centerX:  NSLayoutXAxisAnchor? = nil,
                    centerY:  NSLayoutYAxisAnchor? = nil,
                    width:    CGFloat?             = nil,
                    height:   CGFloat?             = nil) {
        
        translatesAutoresizingMaskIntoConstraints=false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive=true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading!).isActive=true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing!).isActive=true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom!).isActive=true
        }
        if let centerX = centerX{
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY{
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive=true
        }
        if let width = width{
            widthAnchor.constraint(equalToConstant: width).isActive=true
        }
    }
    
}






