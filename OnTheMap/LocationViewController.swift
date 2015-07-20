//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Boris Alexis Gonzalez Macias on 7/19/15.
//  Copyright (c) 2015 PropiedadFacil. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationViewController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationLabel: UITextField!
    
    var origin : UIViewController!
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func submitButton(sender: UIButton) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        CLGeocoder().geocodeAddressString(locationLabel.text, completionHandler: { (placemarks, error)->Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error == nil {
                let place = placemarks[0] as! CLPlacemark
                let coordinate = place.location.coordinate
                Shared.showPreviewLocationVC(self.origin,vc: self, data: ["latitude": coordinate.latitude, "longitude": coordinate.longitude, "mapString": "\(place.locality), \(place.administrativeArea)"])
            }else{
                Shared.showError(self, errorString: error.localizedDescription)
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationLabel.delegate = self
    }
    
    // Getting rid of keyboard after hitting return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Getting rid of keyboard after touching outside inputs
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event!)
    }
}