//
//  ViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 15/03/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase
import Mapbox



class ViewController: UIViewController, SideBarDelegate, MGLMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MGLMapView!
    
    var sideBar: SideBar = SideBar()
    
    var skateparks = [Skatepark]()
    
    var locationManager = CLLocationManager()
    
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")
    
    
    //Filtering annotations for sidebar
    
    func sideBarDidSelectButtonAtIndex(_ index: Int) {
       mapView.removeAnnotations(mapView.annotations!)
        
        for park in skateparks {
            
            if index == 0 {
                addAnnotation(park: park)
            }
            
            if index == 1 && park.type == .park {
                addAnnotation(park: park)
            }
            
            if index == 2 && park.type == .street {
                addAnnotation(park: park)
            }
            
            //Change this to feature the users own personal spots they saved to firebase
            
            if index == 3 {
                addAnnotation(park: park)
            }
            
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Initiates the mapView
        
        mapView.delegate = self
        
        //Sidebar
        
        sideBar = SideBar(sourceView: self.view, skateItems: ["All Skate Spots", "Skateparks", "Street Skating", "My Spots"])
        sideBar.delegate = self
        
        
        // Passing firebase annotation data
        
        locationsRef.observe(.value, with: { snapshot in
            self.skateparks.removeAll()
            
            for item in snapshot.children {
                guard let snapshot = item as? FIRDataSnapshot else { continue }
                
                let newSkatepark = Skatepark(snapshot: snapshot)
                
                self.skateparks.append(newSkatepark)

                self.addAnnotation(park: newSkatepark)
            }
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.sendSubview(toBack: mapView)
    }
    
    
    //Adding annotations on map
    
    func addAnnotation(park: Skatepark) {

        let point = MGLPointAnnotation()
        
        point.coordinate = park.coordinate

        point.title = park.name
        
        point.subtitle = park.subtitle
        
        mapView.addAnnotation(point)
        
        mapView.selectAnnotation(point, animated: true)
        
    }
    
    
    //User can save their location
    @IBAction func findUserLocationAndDropPin(_ sender: UIButton) {
        
        let userLocationCoordinates = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        
        let pinForUserLocation = MGLPointAnnotation()
        
        pinForUserLocation.coordinate = userLocationCoordinates
        
        pinForUserLocation.title = ""
        pinForUserLocation.subtitle = ""
        
        mapView.addAnnotation(pinForUserLocation)
        mapView.showAnnotations([pinForUserLocation], animated: true)
        
        //When the user clicks the button, send the CLLocation Coordinate 2D make to firebase against their user ID
        
        let locationsRef = FIRDatabase.database().reference(withPath: "users/MknkigPqoqN7zb2WAF5aAltEshi2/locations")
        locationsRef.setValue(["lat": locationManager.location?.coordinate.latitude, "lng": locationManager.location?.coordinate.longitude])
        
        //need to add so it doesnt overwrite (add a child?), change the locations so they are actually right (also have to change to just users)

    }
    

    //Show the annotation callout

 func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    
    return true
    

    }
    
    
    //Hide the callout view
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        
        mapView.deselectAnnotation(annotation, animated: false)

    }
    
    //Information button - turn this into 360 image
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }

    //Image for Annotation - Change this for Skatepark/StreetSkating
    
     func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
      
        return nil
        
    }

}
