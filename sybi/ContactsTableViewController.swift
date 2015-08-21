//
//  ContactsTableViewController.swift
//  sybi
//
//  Created by Gisele Sardas on 8/16/15.
//  Copyright (c) 2015 ybus. All rights reserved.
//


import Bolts
import Parse
import CoreLocation

class ContactsTableViewController: UITableViewController, CLLocationManagerDelegate {


    var ids = [String]()
    //var products = [String]()
    var firstName = [String]()
    var lastName = [String]()
    var company = [String]()
    var occupation = [String]()
    var email = [String]()
    var personal_picFiles = [PFFile]()
    var companylogoFiles = [PFFile]()


    var refresher = UIRefreshControl()

    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    
    override func viewDidAppear(animated: Bool) {
        //println("Start")
        
        //check if user has his info saved
        
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("objectId") {
            println(object)
            let email = object as! String
            
            
            //Get user lon and Lat
            //let lon = "25.782324"
            //let lat = "-80.2310801"

            
            
            
            
            
            
            // Save user's latest coordinates
            
            // Let's update his info
            //println("Let's get his lat and lon")
            let defaults = NSUserDefaults.standardUserDefaults()

            
            if let object = NSUserDefaults.standardUserDefaults().objectForKey("lat") {
                //println(object)
                let lat = object as! String
                
                if let object = NSUserDefaults.standardUserDefaults().objectForKey("lon") {
                    //println(object)
                    let lon = object as! String
                    
                    if let object = NSUserDefaults.standardUserDefaults().objectForKey("hour") {
                        //println(object)
                        let hour = object as! Int
                        println(hour)
                    
            
                
                    startLocation = nil
                
                    var query = PFQuery(className:"Contacts")
                    query.getObjectInBackgroundWithId(email) {
                        (object, error) -> Void in
                        if error != nil {
                            println(error)
                        } else {
                            if let object = object {
                                println("Saving gps with latest LAT and LON")
                                //println(lat)
                                //println(lon)
                                object["lat"] = lat
                                object["lon"] = lon
                               var hour2 = String(hour)
                                object["hour"] = hour2
                            
                            
                            }
                            //println("Updating user position in Parse")
                            object!.saveInBackground()
                        }
                    }
                  }
                
                }
                    
                
                
                
            }else{
                
                    println("First Time User")
                    let alertController = UIAlertController(title: "Welcome to Sybi", message:
                        "Click on Info to update your user info", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                
                
                
            
                
            }
                
        }

            
            

    }
    
    
    
    
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!)
    {
        
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("lat") {
            //println("sleeping 8")
            //sleep(8)
        }
        else{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("1.000", forKey: "lat")
            defaults.setObject("1.000", forKey: "lon")
            defaults.setObject("1.000", forKey: "hour")
            defaults.synchronize()
        
        }
        
        
        
        
        //println("function startUpdatingLocation")
        var latestLocation: AnyObject = locations[locations.count - 1]
        
       let lat = String(format: "%.4f",
            latestLocation.coordinate.latitude)
       let lon = String(format: "%.4f",
            latestLocation.coordinate.longitude)
        //println(lat)
        //println(lon)
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(lat, forKey: "lat")
        defaults.setObject(lon, forKey: "lon")
        defaults.setObject(hour, forKey: "hour")
        defaults.synchronize()
        

        
        
//        //horizontalAccuracy.text = String(format: "%.4f",
//            latestLocation.horizontalAccuracy)
//        //altitude.text = String(format: "%.4f",
//            latestLocation.altitude)
//        //verticalAccuracy.text = String(format: "%.4f",
//            latestLocation.verticalAccuracy)
        
        
        if startLocation == nil {
            startLocation = latestLocation as! CLLocation
        }
        
        var distanceBetween: CLLocationDistance =
        latestLocation.distanceFromLocation(startLocation)
        
        //distance.text = String(format: "%.2f", distanceBetween)
    }
    
    
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
            
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Initializing app
        println("Start")
        
        //check if user has his info saved
        
        if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
            
            //Get user lon and Lat
            let lon = "25.782324"
            let lat = "-80.2310801"
            
            
            // Save user's latest coordinates
            
            
            
            
        }
        else{
            println("First time user")
            
            var alert = UIAlertController(title: "Welcome", message: "Save your info to get started. Click on Contact!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            tabBarController?.selectedIndex = 1
            
        }

        
        
        //Setting up pull to refresh
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh:", forControlEvents:.ValueChanged)
        
        self.refreshControl = refresher
    

        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //println("get startUpdatingLocation")
        locationManager.startUpdatingLocation()
    
        
        
        //QUERYING Contacts
        
        var query = PFQuery(className:"Contacts")
        query.findObjectsInBackgroundWithBlock {
            (objectproducts, error) -> Void in
            
            
            //READ NSDEFAULTS
            let defaults = NSUserDefaults.standardUserDefaults()
            
            
            
            //Check if user has his info, otherwise there is no point looking for contacts....
            if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
                
                
            println("Getting lat1, lon1 and hour1") // this is his info so we can check with other users....
                
            let object = NSUserDefaults.standardUserDefaults().objectForKey("lat")
                //println(object)
                let lat11 = object as! String
                var lat1:Double=NSString(string: lat11).doubleValue
                println(lat1)
            
            let object1 = NSUserDefaults.standardUserDefaults().objectForKey("lon")
                //println(object)
                let lon11 = object1 as! String
                var lon1:Double=NSString(string: lon11).doubleValue
                println(lon1)
            
            let object2 = NSUserDefaults.standardUserDefaults().objectForKey("hour")
                //println(object)
                let hour1 = object2 as! Int
                println("hour1")
                println(hour1)
        
            let object3 = NSUserDefaults.standardUserDefaults().objectForKey("email")
                //println(object)
                let userid1 = object3 as! String
                println("userid1")
                println(userid1)
            
            
            
            for objectprod1 in objectproducts! {
                
                
                println("getting contacts from Parse")
                
                //var hour = objectprod1["hour"] as! String
                //println(hour)
                let lat  = objectprod1["lat"] as! String
                println(lat)
                var lat2:Double=NSString(string: lat).doubleValue
                let lon  = objectprod1["lon"] as! String
                var lon2:Double=NSString(string: lon).doubleValue
                println(lon)
                
                let hour  = objectprod1["hour"] as! String
                var hour2:Int=NSString(string: hour).integerValue
                println("hour2")
                println(hour2)
                
                let userid2  = objectprod1["email"] as! String
                println(userid2)
                

                if ((lat1 >= (lat2 - 0.01) && lat1 <= (lat2 + 0.01)) || userid2 == "fernando.azevedo@gmail.com"){
                        println("lat ok")
                        if ((lon1 >= (lon2 - 0.01) && lon1 <= (lon2 + 0.01)) || userid2 == "fernando.azevedo@gmail.com"){
                            println("lon ok")
                               if (hour1 == hour2  || userid2 == "fernando.azevedo@gmail.com"){
                                    if (userid1 != userid2 || userid2 == "fernando.azevedo@gmail.com") {
                                         println("CONTATOS ESTAO PERTOS")
                                        
                                        
                                        self.lastName.append(objectprod1["lastName"] as! String)
                                        println(objectprod1["lastName"] as! String)
                                        self.firstName.append(objectprod1["firstName"] as! String)
                                        println(objectprod1["firstName"] as! String)
                                        self.company.append(objectprod1["company"] as! String)
                                        println(objectprod1["company"] as! String)
                                        self.occupation.append(objectprod1["occupation"] as! String)
                                        println(objectprod1["occupation"] as! String)
                                        self.email.append(objectprod1["email"] as! String)
                                        println(objectprod1["email"] as! String)
                                        var id = objectprod1.objectId
                                        self.ids.append((id as String?)!)
                                        
                                        println("vendo as imagens")
                                        if (objectprod1["personal_pic"] != nil){
                                        self.personal_picFiles.append(objectprod1["personal_pic"] as! PFFile)
                                        }
                                        if (objectprod1["companylogo"] != nil){
                                        self.companylogoFiles.append(objectprod1["companylogo"] as! PFFile)
                                        }
                                        
                                        println("reload table function")
                                        self.tableView.reloadData()
                                        
                                        
                                        
                                    }
                                    else{
                                         println("it was the same user")
                                    }
                               }
                        }
                }
            }

            }
            
        }
        
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    func refresh(sender:AnyObject) {
        
        println("Refreshing table....")
        self.refresher.endRefreshing()
        
        self.firstName.removeAll(keepCapacity: true)
        self.lastName.removeAll(keepCapacity: true)
        self.company.removeAll(keepCapacity: true)
        self.occupation.removeAll(keepCapacity: true)
        self.email.removeAll(keepCapacity: true)

        self.ids.removeAll(keepCapacity: true)
        
        
        //QUERYING Contacts
        
        var query = PFQuery(className:"Contacts")
        query.findObjectsInBackgroundWithBlock {
            (objectproducts, error) -> Void in
            
            
            //READ NSDEFAULTS
            let defaults = NSUserDefaults.standardUserDefaults()
            
            
            
            //Check if user has his info, otherwise there is no point looking for contacts....
            if let object = NSUserDefaults.standardUserDefaults().objectForKey("email") {
                
                
                println("Getting lat1, lon1 and hour1") // this is his info so we can check with other users....
                
                let object = NSUserDefaults.standardUserDefaults().objectForKey("lat")
                //println(object)
                let lat11 = object as! String
                var lat1:Double=NSString(string: lat11).doubleValue
                println(lat1)
                
                let object1 = NSUserDefaults.standardUserDefaults().objectForKey("lon")
                //println(object)
                let lon11 = object1 as! String
                var lon1:Double=NSString(string: lon11).doubleValue
                println(lon1)
                
                let object2 = NSUserDefaults.standardUserDefaults().objectForKey("hour")
                //println(object)
                let hour1 = object2 as! Int
                println("hour1")
                println(hour1)
                
                let object3 = NSUserDefaults.standardUserDefaults().objectForKey("email")
                //println(object)
                let userid1 = object3 as! String
                println("userid1")
                println(userid1)
                
                
                
                for objectprod1 in objectproducts! {
                    
                    
                    println("getting contacts from Parse")
                    
                    //var hour = objectprod1["hour"] as! String
                    //println(hour)
                    let lat  = objectprod1["lat"] as! String
                    println(lat)
                    var lat2:Double=NSString(string: lat).doubleValue
                    let lon  = objectprod1["lon"] as! String
                    var lon2:Double=NSString(string: lon).doubleValue
                    println(lon)
                    
                    let hour  = objectprod1["hour"] as! String
                    var hour2:Int=NSString(string: hour).integerValue
                    println("hour2")
                    println(hour2)
                    
                    let userid2  = objectprod1["email"] as! String
                    println(userid2)
                    
                    
                    if (lat1 >= (lat2 - 0.01) && lat1 <= (lat2 + 0.01)){
                        println("lat ok")
                        if (lon1 >= (lon2 - 0.01) && lon1 <= (lon2 + 0.01)){
                            println("lon ok")
                            if (hour1 == hour2){
                                if (userid1 != userid2 || userid1 == "fernando.azevedo@gmail.com") {
                                    println("CONTATOS ESTAO PERTOS")
                                    
                                    
                                    self.lastName.append(objectprod1["lastName"] as! String)
                                    println(objectprod1["lastName"] as! String)
                                    self.firstName.append(objectprod1["firstName"] as! String)
                                    println(objectprod1["firstName"] as! String)
                                    self.company.append(objectprod1["company"] as! String)
                                    println(objectprod1["company"] as! String)
                                    self.occupation.append(objectprod1["occupation"] as! String)
                                    println(objectprod1["occupation"] as! String)
                                    self.email.append(objectprod1["email"] as! String)
                                    println(objectprod1["email"] as! String)
                                    var id = objectprod1.objectId
                                    self.ids.append((id as String?)!)
                                    
                                    self.personal_picFiles.append(objectprod1["personal_pic"] as! PFFile)
                                    self.companylogoFiles.append(objectprod1["companylogo"] as! PFFile)
                                    
                                    
                                    println("reload table function")
                                    self.tableView.reloadData()
                                    
                                    
                                    
                                }
                                else{
                                    println("it was the same user")
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
        //self.tableView.reloadData()
        
        
    }
    
    
    
    
    
//    
//    func refresh(){
//        
//        println("refreshed")
//        updateTable()
//    }
    
    
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        var detailScene = segue.destinationViewController as! SingleContactViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            //let selectedPhoto = photos[indexPath.row]
            //detailScene.currentPhoto = selectedPhoto
            let row2 = Int(indexPath.row)
            
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setValue(ids[row2], forKey: "objectIdContact")
             prefs.setValue(email[row2], forKey: "emailContact")
            prefs.synchronize()
            
            
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return firstName.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        NSLog("myCell")
        // Update - replaced as with as!
        
        var myCell:PFTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell
        
        NSLog(firstName[indexPath.row])
        NSLog("%i",indexPath.row)
        myCell.name.text = firstName[indexPath.row]
        myCell.lastName.text = lastName[indexPath.row]
        myCell.occupation.text = occupation[indexPath.row]
        myCell.company.text = company[indexPath.row]
        
        personal_picFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData, error) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                
                myCell.personal_pic.image = image
            }
            
            
        }
        
        
        companylogoFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData, error) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                
                myCell.companylogo.image = image
            }
            
            
        }
        
        return myCell
        
    }
    
    
    


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
