//
//  BaseViewController.swift
//  Ritbus
//
//  Created by User on 02/03/20.
//  Copyright © 2020 Radya Labs. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage
import Moya

class BaseViewController: UIViewController {

    var delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 0.33)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Alert
    func showPopupWith(title:String, content:String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    func showPopupWith(title:String, content:String, button: String, action:@escaping ((UIAlertAction) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default, handler: action)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func showPopupWith(title:String, content:String, button1: String, button2: String, action1:@escaping ((UIAlertAction) -> Void) = { _ in }, action2:@escaping ((UIAlertAction) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let ok = UIAlertAction(title: button1, style: .default, handler: action1)
        let cancel = UIAlertAction(title: button2, style: .default, handler: action2)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Overlay
    func showOverlayViewController(_ popup:UIViewController) {
        popup.view.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.1019607843, blue: 0.1254901961, alpha: 0.8)
        popup.modalTransitionStyle = .crossDissolve
        popup.modalPresentationStyle = .overCurrentContext
        
        if let tabBar = tabBarController {
            tabBar.present(popup, animated: true, completion: nil)
        }else{
            present(popup, animated: true, completion: nil)
        }
    }
    
    // MARK: - Action
    func popBack(_ message:String="Id Not Found"){
        self.showPopupWith(title: "", content: message, button: "Ok") { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .changed || sender.state == .ended {
            view.endEditing(true)
        }
    }
    
    func handleKeyboard(notification: Notification) {

      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
        view.layoutIfNeeded()
        return
      }
      
      guard
        let info = notification.userInfo,
        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
          return
      }
      
      let keyboardHeight = keyboardFrame.cgRectValue.size.height
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
}

extension BaseViewController: NVActivityIndicatorViewable {
    func showLoading() {
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading", type: .ballRotateChase, fadeInAnimation: nil)
    }
    func hideLoading() {
        self.stopAnimating(nil)
    }
}
