//
//  SaveSpotViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 12/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase
import Mapbox

class SaveSpotViewController: UIViewController {
    
    @IBOutlet weak var skateTitleText: UITextField!
    @IBOutlet weak var skateStyleText: UITextField!
    @IBOutlet weak var skateTypeText: UITextField!
    
    var skateparks = [Skatepark]()
    
    var user: FIRUser!
    
    var locationManager = CLLocationManager()
    
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addPinAndSaveLocation(_ sender: Any) {
    
        let userLocationCoordinates = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        
        let pinForUserLocation = MGLPointAnnotation()
        
        pinForUserLocation.coordinate = userLocationCoordinates
        
//        guard let skateTitleText = skateTitleText.text, let skateStyleText = skateStyleText.text, let skateTypeText = skateTypeText.text else { return }
//        
//        guard skateTitleText.characters.count > 0, skateStyleText.characters.count > 0, skateTypeText.characters.count > 0 else {
//            
//            return
//            
//        }
        
        //When the user clicks the button, send the CLLocation Coordinate 2D make to firebase against their user ID
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        let locationsRef = FIRDatabase.database().reference().child("users").child(uid).child("personalLocations").childByAutoId()
        
    //    let Skatepark: [String: Any] = ["name": skateTitleText, "subtitle": skateStyleText, "type": skateTypeText]
        
        locationsRef.setValue(["lat": locationManager.location?.coordinate.latitude, "lng": locationManager.location?.coordinate.longitude, "name": "User", "subtitle": "Street Skating", "type": 1])
        
       
    
    }

}
