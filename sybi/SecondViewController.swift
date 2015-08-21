//
//  SecondViewController.swift
//  sybi
//
//  Created by Gisele Sardas on 8/16/15.
//  Copyright (c) 2015 ybus. All rights reserved.
//

import UIKit
import Parse

class SecondViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var office: UITextField!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var personal_pic: UIImageView!
    @IBOutlet weak var companylogo: UIImageView!
    @IBOutlet weak var choose_personal_pic: UIButton!
    @IBOutlet weak var choose_company_logo: UIImageView!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    var imageFiles = [PFFile]()
    
    
    var imagePicker: UIImagePickerController!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
   var image_type : String = String()
    
    @IBAction func choose_image(sender: AnyObject) {
        
        image_type = "personal"
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    @IBAction func choose_logo(sender: AnyObject) {
        
        image_type = "company"
        var image2 = UIImagePickerController()
        image2.delegate = self
        image2.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image2.allowsEditing = false
        
        self.presentViewController(image2, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerCompany(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
        println(image_type)
        if (image_type == "company"){
            companylogo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else{
            personal_pic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    

    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        //imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
        println(image_type)
        if (image_type == "company"){
            companylogo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else{
            personal_pic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
      
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        println("Personal Image Selected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        personal_pic.image = image
        
    }
    
    @IBAction func saveFunction(sender: AnyObject) {
        
        
        println(self.lastName.text)
        println(self.firstName.text)
        println(self.email.text)
        println(self.company.text)
        println(self.occupation.text)
        println(self.mobile.text)
        println(self.office.text)
        
        
        if (self.lastName.text == "" || self.firstName.text == "" || self.email.text == "" || self.occupation.text == "" ||  self.mobile.text == "" || self.office.text == "" ||  self.company.text == ""){
        println("user did not fill all fields")
            
            var alert = UIAlertController(title: "Hummmm", message: "You should fill in all fields", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        
        }
        
        println("Saving user's info")
        
        //Lets's see if user is updating
        println("Lets's see if user is updating")
        
        var objectId = ""
     
        
        //Retrieving user Id from Parse
        println("Retrieving user Id from Parse")
        var query = PFQuery(className:"Contacts")
        query.whereKey("email", equalTo:self.email.text)
        //query.orderByDescending("objectId")
        query.limit = 1
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) Contacts.")
                
                
                
            if (objects!.count == 0 ) {
                // Log details of the failure
                //println("Error: \(error!) \(error!.userInfo!)")
                
                //Let's save it for the first time
                println("Let's save it for the first time")
                
              
                
                var contact = PFObject(className:"Contacts")
                contact["lastName"] = self.lastName.text
                contact["firstName"] =  self.firstName.text
                contact["occupation"] = self.occupation.text
                contact["company"] = self.company.text
                contact["email"] =  self.email.text
                contact["mobile"] = self.mobile.text
                contact["office"] = self.office.text
                contact["lat"] = "1.000"
                contact["lon"] = "1.000"
                contact["hour"] = "1.000"
                
                 println("images")
                 println(self.personal_pic)
              
                //contact["userpic"] = self.personal_pic
                let imageData = UIImagePNGRepresentation(self.personal_pic.image)
                let imageFile = PFFile(name: "personal_pic.png", data: imageData)
                contact["personal_pic"] = imageFile
                
                
                //contact["companylogo"] = self.companylogo
                let imageData2 = UIImagePNGRepresentation(self.companylogo.image)
                let imageFile2 = PFFile(name: "companylogo.png", data: imageData2)
                contact["companylogo"] = imageFile2

                
                println("saving in background")
                
                
                contact.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        println("Saved")
                    }}
                        

                        
                        
                
    
                        
                        
                                
                                
                        // creating invitation from fernando.azevedo@gmail.com and backward
                                
                                var invite = PFObject(className:"Invites")
                                        invite["from"] = "fernando.azevedo@gmail.com"
                                        invite["para"] = self.email.text
                    
                                invite.saveInBackgroundWithBlock {
                                    
                                    (success: Bool, error: NSError?) -> Void in
                                    
                                    if (success) {
                                        println("Saved invitation1");
                                    }
                                }
                                
                                
                                var invite2 = PFObject(className:"Invites")
                                invite2["from"] = self.email.text
                                invite2["para"] = "fernando.azevedo@gmail.com"
                                
                                invite2.saveInBackgroundWithBlock {
                                    
                                    (success: Bool, error: NSError?) -> Void in
                                    
                                    if (success) {
                                        println("Saved invitation2");
                                    }
                                }
                                
                                
                                
                                
                                
                        // Saving to Local Storage
                        println("Saving to Local Storage for the 1st time")
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(self.lastName.text, forKey: "lastName")
                        defaults.setObject(self.firstName.text, forKey: "firstName")
                        defaults.setObject(self.occupation.text, forKey: "occupation")
                        defaults.setObject(self.company.text, forKey: "company")
                        defaults.setObject(self.email.text, forKey: "email")
                        defaults.setObject(self.mobile.text, forKey: "mobile")
                        defaults.setObject(self.office.text, forKey: "office")
                        defaults.synchronize()
                        
                        println(defaults.stringForKey("lastName"))
                        println(defaults.stringForKey("email"))
                        
                
                        sleep(5)
                
                        //Retrieving user Id from Parse
                        var query = PFQuery(className:"Contacts")
                        query.whereKey("email", equalTo:self.email.text)
                        query.orderByDescending("CreatedAt")
                        query.limit = 1
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                println("Successfully retrieved \(objects!.count) scores.")
                                // Do something with the found objects
                                if let objects = objects as? [PFObject] {
                                    for object in objects {
                                        println(object.objectId)
                                        
                                        println("Saving ID to Local Storage for the 1st time")
                                        let defaults = NSUserDefaults.standardUserDefaults()
                                        defaults.setObject(object.objectId, forKey: "objectId")
                                        
                                        
                                        var alert = UIAlertController(title: "Saved", message: "All Set! Happy Networking!", preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                // Log details of the failure
                                println("Error: \(error!) \(error!.userInfo!)")
                            }
                        }
                        
                        
                        
                    } else {
                        println("Not Saved");
         
                
            }
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println("Found id: ")
                        println(object.objectId)
                        println(object.createdAt)
                        
                        objectId = String(stringInterpolationSegment: object.objectId)
                      
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(object.objectId, forKey: "objectId")
                        
                        
                        
                        // Let's update his info
                        println("Let's update his info")
                        println(objectId)
                        var uuidString:String = objectId as! String
                        println(uuidString)
                        let newString = uuidString.stringByReplacingOccurrencesOfString("Optional(", withString: "")
                        let newString2 = newString.stringByReplacingOccurrencesOfString(")", withString: "")
                        println(newString2)
                        let newString3 = newString2.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        
                        
                        
                        var query = PFQuery(className:"Contacts")
                        query.getObjectInBackgroundWithId(newString3) {
                            (object, error) -> Void in
                            if error != nil {
                                println(error)
                            } else {
                                if let object = object {
                                    object["lastName"] = self.lastName.text
                                    object["firstName"] = self.firstName.text
                                    object["occupation"] = self.occupation.text
                                    object["company"] = self.company.text
                                    object["email"] = self.email.text
                                    object["mobile"] = self.mobile.text
                                    object["office"] = self.office.text
                                    object["lat"] = "1"
                                    object["lon"] = "1"
                                    object["hour"] = "1"
                                    
                                    if (self.personal_pic.image != nil){
                                    let imageData = UIImagePNGRepresentation(self.personal_pic.image)
                                    let imageFile = PFFile(name: "personal_pic.png", data: imageData)
                                    object["personal_pic"] = imageFile
                                    }
                                    if (self.companylogo.image != nil){
                                    let imageData2 = UIImagePNGRepresentation(self.companylogo.image)
                                    let imageFile2 = PFFile(name: "companylogo.png", data: imageData2)
                                    object["companylogo"] = imageFile2
                                    }
                                    object.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                                        
                                        if success == false {
                                            
                                            println("Could Not Save your info")
                                            
                                        } else {
                                            
                                            println("Your info is saved!")
                                            var alert = UIAlertController(title: "Saved", message: "Info Saved", preferredStyle: UIAlertControllerStyle.Alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                            self.presentViewController(alert, animated: true, completion: nil)
                                        }
                                        
                                    }
                                    
                                    
                                }

                                
                                
                                // Saving to Local Storage
                                println("Saving to Local Storage")
                                let defaults = NSUserDefaults.standardUserDefaults()
                                var myValue:NSString = self.lastName.text
                                defaults.setObject(myValue, forKey: "lastName")
                                defaults.setObject(self.firstName.text, forKey: "firstName")
                                defaults.setObject(self.occupation.text, forKey: "occupation")
                                defaults.setObject(self.company.text, forKey: "company")
                                defaults.setObject(self.email.text, forKey: "email")
                                defaults.setObject(self.mobile.text, forKey: "mobile")
                                defaults.setObject(self.office.text, forKey: "office")
                                defaults.setObject(newString3, forKey: "objectId")
                                
                                
                                defaults.synchronize()
                                
                                
                                
                            }
                        }
                        
                    }
                }
                

                
                

                
                
                
            }
        }
        
        
        

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        lastName.delegate = self
        firstName.delegate = self
        occupation.delegate = self
        company.delegate = self
        email.delegate = self
        mobile.delegate = self
        office.delegate = self
        
        

        
        
          let defaults = NSUserDefaults.standardUserDefaults()

        if let object = NSUserDefaults.standardUserDefaults().objectForKey("lastName") {
            println(object)
            self.lastName.text = object as! String
        }
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("firstName") {
            println(object)
            self.firstName.text = object as! String
        }
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("occupation") {
            println(object)
            self.occupation.text = object as! String
        }
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("company") {
            println(object)
            self.company.text = object as! String
        }
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("mobile") {
            println(object)
            self.mobile.text = object as! String
        }
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("office") {
            println(object)
            self.office.text = object as! String
        }
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            println(object)
            self.email.text = object as! String
        }
        
        
        //GET the pictures
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("objectId") {
            println(object)
            //QUERYING PRODUCTS
            
            var query = PFQuery(className:"Contacts")
            query.whereKey("objectId", equalTo:object)
            query.findObjectsInBackgroundWithBlock {
                (objectproducts, error) -> Void in
    
                for object1 in objectproducts! {

                    self.imageFiles.append(object1["companylogo"] as! PFFile)
                    self.imageFiles.append(object1["personal_pic"] as! PFFile)
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

        

        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true)
//    }

}

