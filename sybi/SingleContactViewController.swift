//
//  SingleContactViewController.swift
//  sybi
//
//  Created by Gisele Sardas on 8/18/15.
//  Copyright (c) 2015 ybus. All rights reserved.
//

import UIKit
import Parse
import AddressBook
import AddressBookUI


class SingleContactViewController: UIViewController {

    @IBOutlet weak var personal_pic: UIImageView!
    @IBOutlet weak var companylogo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var office: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var imageFiles = [PFFile]()
    
    
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()

    

    
    
    
    
    @IBAction func refresh(sender: AnyObject) {
        
        
        self.statusLabel.text = "refreshing...."

        
        
        
        //Check first if user has let access to his info
        
        
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            let email1 = object as! String
            println(email1)
            
            if let object = NSUserDefaults.standardUserDefaults().objectForKey("emailContact") {
                let email2 = object as! String
                println(email2)
                
                
                var query = PFQuery(className:"Invites")
                query.whereKey("from", equalTo:email2)
                query.whereKey("para", equalTo:email1)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    println(objects!.count)
                    if error == nil {
            
                        if (objects!.count > 0 || email2 == "fernando.azevedo@gmail.com"){
                            
                            println("INVITATION FOUND")
                            self.statusLabel.text = "invitation found!"
                            self.statusLabel.text = "invitation found!"
                            
                            
                            //Get user's id
                            let prefs = NSUserDefaults.standardUserDefaults()
                            var id = prefs.stringForKey("objectIdContact")
                            println(id)
                            
                            // GET USER INFO BECAUSE IT HAS BEEN INVITED!
                            var query = PFQuery(className:"Contacts")
                            query.getObjectInBackgroundWithId(id!) {
                                (object, error) -> Void in
                                if error != nil {
                                    println(error)
                                } else {
                                    if let object = object {
                                        self.name.text  = object["firstName"] as! String
                                        self.lastName.text  = object["lastName"] as! String
                                        self.occupation.text = object["occupation"] as! String
                                        self.company.text = object["company"] as! String
                                        self.email.text = object["email"] as! String
                                        self.office.text = object["office"] as! String
                                        self.mobile.text = object["mobile"] as! String
                                        
                                        
                                        self.imageFiles.append(object["companylogo"] as! PFFile)
                                        self.imageFiles.append(object["personal_pic"] as! PFFile)
                                        self.imageFiles[0].getDataInBackgroundWithBlock{
                                            (imageData, error) -> Void in
                                            if error == nil {
                                                let image = UIImage(data: imageData!)
                                                self.companylogo.image = image
                                            }
                                        }
                                        self.imageFiles[1].getDataInBackgroundWithBlock{
                                            (imageData, error) -> Void in
                                            if error == nil {
                                                let image = UIImage(data: imageData!)
                                                self.personal_pic.image = image
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                            
                        else{
                            
                            println("no invitation found")
                            self.statusLabel.text = "No invitation found yet"
                        }
                        
                        
                        
                        
                    }
                    else{
                        println("Error: \(error!) \(error!.userInfo!)")
                        
                    }
                    
                    
                }
                
            }
            
        }

        
        
        
        
    }
    

    
    
    @IBAction func invite(sender: AnyObject) {
     
    
        var invite = PFObject(className:"Invites")
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            
            let email1 = object as! String

            if let object = NSUserDefaults.standardUserDefaults().objectForKey("emailContact") {
                
                let email2 = object as! String
                invite["from"] = email1
                invite["para"] = email2
            }
 
        }
        
        invite.saveInBackgroundWithBlock {
            
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                println("Saved");
            }
        }
        
    }
    
    
   
    
    
    @IBAction func create_contact(sender: AnyObject) {

        
        let petRecord: ABRecordRef = ABPersonCreate().takeRetainedValue()
        ABRecordSetValue(petRecord, kABPersonFirstNameProperty, self.name.text, nil)
        ABRecordSetValue(petRecord, kABPersonLastNameProperty, self.lastName.text, nil)
        ABRecordSetValue(petRecord, kABPersonJobTitleProperty, self.occupation.text, nil)
        ABRecordSetValue(petRecord, kABPersonOrganizationProperty, self.company.text, nil)
       

        let email: ABMutableMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(email, self.email.text, kABPersonPhoneMainLabel, nil)
        ABRecordSetValue(petRecord, kABPersonEmailProperty, email, nil)
        
        
        let phoneNumbers: ABMutableMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(phoneNumbers, self.office.text, kABPersonPhoneMainLabel, nil)
        ABRecordSetValue(petRecord, kABPersonPhoneProperty, phoneNumbers, nil)
        
        ABAddressBookAddRecord(addressBookRef, petRecord, nil)
        if ABAddressBookHasUnsavedChanges(addressBookRef){
            var err: Unmanaged<CFErrorRef>? = nil
            let savedToAddressBook = ABAddressBookSave(addressBookRef, &err)
            if savedToAddressBook {
                println("Successully saved changes.")
                var alert = UIAlertController(title: "Saved", message: "Contactt Added to your Address Book", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                println("Couldn't save changes.")
            }
        } else {
            println("No changes occurred.")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inviteButton.hidden = false
        self.refreshButton.hidden = false


        
        
        //Check first if user has let access to his info
        
        
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            let email1 = object as! String
            println(email1)
            
            if let object = NSUserDefaults.standardUserDefaults().objectForKey("emailContact") {
                let email2 = object as! String
                println(email2)
                
                var query = PFQuery(className:"Invites")
                query.whereKey("from", equalTo:email2)
                query.whereKey("para", equalTo:email1)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    println(objects!.count)
                    if error == nil {
                        if (objects!.count > 0){
                            
                            println("INVITATION FOUND")
                            self.statusLabel.text = "Users Connected"
                            self.inviteButton.hidden = true
                            self.refreshButton.hidden = true
                            
                            
                            //Get user's id
                            let prefs = NSUserDefaults.standardUserDefaults()
                            var id = prefs.stringForKey("objectIdContact")
                            println(id)
                            
                            // GET USER INFO BECAUSE IT HAS BEEN INVITED!
                            var query = PFQuery(className:"Contacts")
                            query.getObjectInBackgroundWithId(id!) {
                                (object, error) -> Void in
                                if error != nil {
                                    println(error)
                                } else {
                                    if let object = object {
                                        self.name.text  = object["firstName"] as! String
                                        self.lastName.text  = object["lastName"] as! String
                                        self.occupation.text = object["occupation"] as! String
                                        self.company.text = object["company"] as! String
                                        self.email.text = object["email"] as! String
                                        self.office.text = object["office"] as! String
                                        self.mobile.text = object["mobile"] as! String
                                        
                                        
                                        self.imageFiles.append(object["companylogo"] as! PFFile)
                                        self.imageFiles.append(object["personal_pic"] as! PFFile)
                                        self.imageFiles[0].getDataInBackgroundWithBlock{
                                            (imageData, error) -> Void in
                                            if error == nil {
                                                let image = UIImage(data: imageData!)
                                                self.companylogo.image = image
                                            }
                                        }
                                        self.imageFiles[1].getDataInBackgroundWithBlock{
                                            (imageData, error) -> Void in
                                            if error == nil {
                                                let image = UIImage(data: imageData!)
                                                self.personal_pic.image = image
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                        
                        }
                        
                        else{
                        
                           println("no invitation found")
                           self.statusLabel.text = "No invitation found."
                        }
                        
                        
                        
                        
                    }
                    else{
                        println("Error: \(error!) \(error!.userInfo!)")
                     
                    }
                
                
            }
            
        }
        
        }
        
        
        

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
