//
//  ViewController.swift
//  PrestaNotificationsF
//
//  Created by Ignas Paulionis on 04/01/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
  
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        //self.performSegue(withIdentifier: "toNotificationActivity", sender: self)
        // Do any additional setup after loading the view, typically from a nib.

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getPrestaModule(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://addons.prestashop.com/en/order-management/24010-mobile-order-support-android-notifications.html")!)
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        //self.performSegue(withIdentifier: "toNotificationActivity", sender: self)
        let token = FIRInstanceID.instanceID().token()!
        print(token)
        
        
        //Get login values
        let username = usernameTextField.text;
        let password = passwordTextField.text;
        
        let json = ["email_username":username, "password":password, "device_id": token]
        let url = "https://bm.prestanotifications.com/login_ios.php"
        
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers:nil).responseJSON
            { response in
                if let JSON = response.result.value as? NSDictionary{
                    print(JSON)
                    let responce = JSON["code"] as? NSNumber
                    
                
                    
                    if (responce==0) {
                        let preferences = UserDefaults.standard
                        preferences.set(username, forKey: "usernameLogin");
                        preferences.set(password, forKey: "passwordLogin");
                        self.usernameTextField.text = " "
                        self.passwordTextField.text = " "
                        preferences.synchronize();
                        self.performSegue(withIdentifier: "toNotificationActivity", sender: self)
                    }   else {
                        self.alertMessage(message: "Invalid user!");
                        self.passwordTextField.text = ""
                        return;
                    }
        
    }
    }
 
}

    

 func alertMessage(message:String){
    let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: UIAlertControllerStyle.alert);
    let okButton = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil);
    alert.addAction(okButton);
    self.present(alert, animated: true, completion: nil);
 }
 
    
 
 
 

}

