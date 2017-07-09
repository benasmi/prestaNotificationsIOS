//
//  PopControllerClass.swift
//  PrestaNotificationsF
//
//  Created by Benas on 23/01/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PopControllerClass : UIViewController{
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferences.set(true, forKey: "dismissAll")
    }
    
    @IBAction func goBackButton1(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackButton2(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func dismiss(_ sender: Any) {
        preferences.set(true, forKey: "dismissAll")
        self.performSegue(withIdentifier: "goBackToNotification", sender: self)
    }
   
    @IBAction func logout(_ sender: Any) {
        if isInternetAvailable() {
            self.performSegue(withIdentifier: "goBackToLogin", sender: self)
            /*
             let preferences = UserDefaults.standard
             
             //Aceit Logout
             let username = preferences.string(forKey: "usernameLogin")
             let password = preferences.string(forKey: "passwordLogin")
             
             let json = ["email_username":username, "password":password, "device_id": "123"]
             let url = "https://bm.prestanotifications.com/logouttest.php"
             
             Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers:nil).responseJSON
             { response in
             if let JSON = response.result.value as? NSDictionary{
             print(JSON)
             let responce = JSON["code"] as? NSNumber
             
             if (responce==0) {
             
             preferences.set("", forKey: "usernameLogin");
             preferences.set("", forKey: "passwordLogin");
             preferences.synchronize();
             self.dismiss(animated: true, completion: nil)
             }
             }
             }
             
             */

            }else{
            
                alertMessage(message: "You need internet connection to perfom this action!")
            
        }
        
        
            }
    
    func alertMessage(message:String){
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: UIAlertControllerStyle.alert);
        let okButton = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil);
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil);
    }
    
    
    
}
