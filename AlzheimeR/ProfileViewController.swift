//
//  ProfileViewController.swift
//  AlzheimeR
//
//  Created by Rahman, Parash on 1/14/18.
//

import UIKit

import CoreLocation

var person_name = ""

class ProfileViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var alt = 0.0
    
    //@IBOutlet weak var trackMeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func trackOthers(_ sender: UIButton) {
        person_name = nameTextField.text!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        
        alt = lastLocation.altitude
        
    
    }
}

