//
//  NotificationViewController.swift
//  PrestaNotificationsF
//
//  Created by Ignas Paulionis on 04/01/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//

import UIKit
import Alamofire



class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    var dictionaries = [[:]]
    
    let preferences = UserDefaults.standard
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: Selector("reloadTable:"), name:NSNotification.Name(rawValue: "ReloadHandler"), object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationViewController.begginRefreshing), name: NSNotification.Name(rawValue: "RefreshTable"), object: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 2.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
     
        
        if let dictionary = preferences.object(forKey: "notificationn") as? [[String:String]]{
            
            dictionaries = dictionary
            print("yraaa")
        }else{
            print("neraa")
            //dictionaries = [[:]]
            // Create a dictionary and add it to the array.
            
            let dictionary = ["message": "This is your first message. Swipe to left to delete it",
                              "type":"message",
                              "message_date": "2017-01-01",
                              "order_reference":"",
                              "buyer_name":"Name Surname",
                              "cost" : "",
                              "url" : "www.prestanotifications.com",
                              "payment_method":"",
                              "order_status" : ""]
            
            let dictionary1 = ["message": "",
                              "type":"order",
                              "message_date": "2017-05-07",
                              "order_reference":"#ORDEREF",
                              "buyer_name":"Name Surname",
                              "cost" : "50$",
                              "url" : "www.prestanotifications.com",
                              "payment_method":"via PayPal",
                              "order_status" : "Awaiting..."]

            
            dictionaries[0] = dictionary
            dictionaries.append(dictionary1)
            //Ideti i shared, del erroro
            //dictionaries.remove(at: 0)
        }
        
        print(dictionaries)
        print(dictionaries.count)
        // Do any additional setup after loading the view.
        
    }
    
    // TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaries.count
    }
    
    //When user gets notification
    func begginRefreshing(){
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: "refreshTable", userInfo: nil, repeats: true)
       
        
    }
    
    func refreshTable(){
        
        let dictionary = preferences.object(forKey: "notificationn") as? [[String:String]]
        dictionaries = dictionary!
        print("typa refresheijn")
        tableView.reloadData()
        timer.invalidate()
        
    }
    
   
  

    @IBAction func optionsClicked(_ sender: Any) {
    
        
        let alertController = UIAlertController(title: "What would you like to do ?", message: nil, preferredStyle: .actionSheet)
        
        let dismissButton = UIAlertAction(title: "Dismiss All", style: .default, handler: { (action) -> Void in
                        self.timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: "timerMethod", userInfo: nil, repeats: true)
            
        })
        
        let logoutButton = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            print("logout")
            //self.dismiss(animated: true, completion: nil)
            
            if(isInternetAvailable()){
                let preferences = UserDefaults.standard
                
                //Aceit Logout
                let username = preferences.string(forKey: "usernameLogin")
                let password = preferences.string(forKey: "passwordLogin")
                
                let json = ["email_username":username, "password":password, "device_id": "123"]
                let url = "https://bm.prestanotifications.com/delete_token.php"
                
                Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers:nil).responseJSON
                    { response in
                        if let JSON = response.result.value as? NSDictionary{
                            print(JSON)
                            let responce = JSON["code"] as? NSNumber
                            
                            if (responce==0) {
                                preferences.set("", forKey: "usernameLogin");
                                preferences.set("", forKey: "passwordLogin");
                                preferences.synchronize();
                                self.performSegue(withIdentifier: "fromNotificationToLogin", sender: self)
                            }
                        }
                }

            }else{
                self.alertMessage(message: "You need internet connection to make this action!")
            }
            
        })

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(dismissButton)
        alertController.addAction(logoutButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = dictionaries[indexPath.row]["type"] as!NSString;
        
        let message_date = dictionaries[indexPath.row]["message_date"] as! NSString
        let buyer_name = dictionaries[indexPath.row]["buyer_name"] as! NSString
        let url = dictionaries[indexPath.row]["url"] as! NSString
        
        if(type=="message"){
            let cell:MessageCell = tableView.dequeueReusableCell(withIdentifier: "cellMessage") as! MessageCell
            let message = dictionaries[indexPath.row]["message"] as! NSString
            
            cell.isExpanded = false
            cell.messageLabel.text = message as String
            //cell.messageLabel.text = ""
            cell.messageLabel.updateConstraints()
            cell.date.text = message_date as String
            cell.url.text = url as String
            cell.buyerName.text = url as String
            
            
            return cell
            
        }else{
            let cell:OrderCell = tableView.dequeueReusableCell(withIdentifier: "cellOrder") as! OrderCell
            
            if DeviceType.IS_IPHONE_5{
                cell.orderReferenceLabel.font = cell.paymentMethod.font.withSize(12)
                cell.paymentMethodLabel.font = cell.paymentMethod.font.withSize(12)
                cell.orderStatusLabel.font = cell.paymentMethod.font.withSize(12)
            }
            
            
            
            let order_reference = dictionaries[indexPath.row]["order_reference"] as! NSString
            let cost = dictionaries[indexPath.row]["cost"] as! NSString
            let payment_method = dictionaries[indexPath.row]["payment_method"] as! NSString
            let order_status = dictionaries[indexPath.row]["order_status"] as! NSString
            
            
            cell.isExpanded = false
            cell.orderStatus.text = order_status as String
            cell.url.text = url as String
            cell.paymentMethod.text = payment_method as String
            cell.orderReference.text = order_reference as String
            
           

            return cell
            
        }
        
        
        
    }
  
    
    
    // TableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type_clicked = dictionaries[indexPath.row]["type"] as!NSString;
        
        if(type_clicked=="message"){
            
            guard let cell = tableView.cellForRow(at: indexPath) as? MessageCell
                else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                tableView.beginUpdates()
                print("CLICKED");
                
                //var lineCount = 0;
                let textSize = CGSize(width:cell.messageLabel.frame.size.width, height:CGFloat(Float.infinity));
                let rHeight = lroundf(Float(cell.messageLabel.sizeThatFits(textSize).height))
                let charSize = lroundf(Float(cell.messageLabel.font.lineHeight));
                let lineCount = rHeight/charSize
                let oneLineHeight = rHeight/lineCount
                
                //print("No of lines \(lineCount)")
                //cell.lines = lineCount
                cell.messageLabel.numberOfLines = lineCount
                cell.expandedHeight = rHeight + oneLineHeight
                cell.isExpanded = !cell.isExpanded
                tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
                tableView.endUpdates()
                print(rHeight)
            })
        }else{
            
            guard let cell = tableView.cellForRow(at: indexPath) as? OrderCell
                else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                tableView.beginUpdates()
                print("CLICKED");
                cell.isExpanded = !cell.isExpanded
                tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
                tableView.endUpdates()
                
            })
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let type = dictionaries[indexPath.row]["type"] as!NSString;
        
        if(type=="order"){
            guard let cell = tableView.cellForRow(at: indexPath) as? OrderCell
                else { return }
            UIView.animate(withDuration: 0.2, animations: {
                tableView.beginUpdates()
                print("CLICKED APACIOJ");
                cell.isExpanded = true
                tableView.endUpdates()
            })
        }else{
            
            guard let cell = tableView.cellForRow(at: indexPath) as? MessageCell
                else { return }
            UIView.animate(withDuration: 0.2, animations: {
                tableView.beginUpdates()
                print("CLICKED APACIOJ");
                let textSize = CGSize(width:cell.messageLabel.frame.size.width, height:CGFloat(Float.infinity));
                let rHeight = lroundf(Float(cell.messageLabel.sizeThatFits(textSize).height))
                let charSize = lroundf(Float(cell.messageLabel.font.lineHeight));
                let lineCount = rHeight/charSize
                
                let oneLineHeight = rHeight/lineCount
                
                //print("No of lines \(lineCount)")
                //cell.lines = lineCount
                cell.expandedHeight = rHeight + oneLineHeight
                cell.isExpanded = true
                tableView.endUpdates()
            })

        }
        
       
    }
    
    
    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let type_clicked = dictionaries[indexPath.row]["type"] as!NSString;
        
        if(type_clicked=="message"){
            guard let cell = tableView.cellForRow(at: indexPath) as? MessageCell
                else { return }
            UIView.animate(withDuration: 0.3, animations: {
                tableView.beginUpdates()
                print("CLICKED APACIOJ");
                cell.isExpanded = false
                tableView.endUpdates()
            })
        }else{
            
            guard let cell = tableView.cellForRow(at: indexPath) as? OrderCell
                else { return }
            UIView.animate(withDuration: 0.3, animations: {
                tableView.beginUpdates()
                print("CLICKED APACIOJ");
                cell.isExpanded = false
                tableView.endUpdates()
            })
            
        }
    }
 */
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        
        if editingStyle == .delete {
            dictionaries.remove(at: indexPath.row)
            preferences.set(dictionaries, forKey: "notificationn")
            tableView.reloadData()
        }
    }
    
    
    func alertMessage(message:String){
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: UIAlertControllerStyle.alert);
        let okButton = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil);
        alert.addAction(okButton);
        self.present(alert, animated: true, completion: nil);
    }
    
    func timerMethod(){
        if(dictionaries.count>0){
            print("patenk")
            self.dictionaries.remove(at: 0)
            print(self.dictionaries.count)
            self.tableView.reloadData()

        }else{
            preferences.set(dictionaries, forKey: "notificationn")
            timer.invalidate()
        }
        
    }
    
    
}


