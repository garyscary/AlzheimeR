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
        
        let url = URL(string: "http://52.233.39.60:5000/gps")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "{\"name\":\"\(person_name)\", \"lon\":\"\(lastLocation.coordinate.longitude)\", \"lat\":\"\(lastLocation.coordinate.latitude)\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        print("\(alt)")
    }
}

