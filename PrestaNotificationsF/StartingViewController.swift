//
//  StartingViewController.swift
//  PrestaNotificationsF
//
//  Created by Benas on 16/03/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//

import Foundation
import UIKit

class StartingViewController: UIViewController {
    
    var timer = Timer()
    
    @IBOutlet weak var imgBell: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.performSegue(withIdentifier: "toNotificationActivity", sender: self)
        // Do any additional setup after loading the view, typically from a nib.
        imgBell.transform = imgBell.transform.rotated(by: -30)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.imgBell.transform = CGAffineTransform(rotationAngle: CGFloat(5))
            
        }, completion: nil)
    
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: "goToLogin", userInfo: nil, repeats: true)
        //let rotateAnimation = CABasicAnimation(value(forKeyPath: "transform.rotation"))
        //ro
    }
    
    //When user gets notification
    func goToLogin(){
        timer.invalidate()
        let preferences = UserDefaults.standard
        
        if let username = preferences.string(forKey: "usernameLogin"){
            if(username.isEmpty){
                self.performSegue(withIdentifier: "startingSegue", sender: nil)
            }else{
                self.performSegue(withIdentifier: "fromStartToLogin", sender: self)
            }
        }else{
            self.performSegue(withIdentifier: "startingSegue", sender: nil)
        }

    }
    
}
