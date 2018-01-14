//
//  ViewController.swift
//  AlzheimeR
//
//  Created by Gary Dhillon on 2018-01-13.
//

import UIKit
import SceneKit
import ARKit
import CoreGraphics

import ARCL
import CoreLocation

struct Person : Codable {
    let name: String
    let lat: String
    let lon: String
}
class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    @objc
    var locNodes = [LocationNode]()
    
    @objc func wtvr() {
        print("hello")
        
        let url = URL(string: "http://52.233.39.60:5000/gps")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        var persons = [Person]()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            //let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
            
            do {
                persons = try JSONDecoder().decode([Person].self, from: data!)
                
                for loc in self.locNodes {
                    self.sceneLocationView.removeLocationNode(locationNode: loc)
                }
                
                self.locNodes = [LocationNode]()
                for person in persons {
                    print(person.name)
                    let lat = Double(person.lat)
                    let lon = Double(person.lon)
                    
                    print(lat)
                    print(lon)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                    let location = CLLocation(coordinate: coordinate, altitude: 90)
                    let image = UIImage(named: "art.scnassets/pin.png")!
                    let image3 = self.textToImage(drawText:person.name, inImage:image, atPoint:CGPoint(x:0,y:0))
                    
                    let annotationNode = LocationAnnotationNode(location: location, image: image3)
                    annotationNode.scaleRelativeToDistance = true
                    
                    self.locNodes.append(annotationNode)
                    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

                }
                
            } catch {
                print("error")
            }
            
            
            
        }
        task.resume()
        
        
        let coordinate = CLLocationCoordinate2D(latitude: 49.26225, longitude: -123.2452)
        let location = CLLocation(coordinate: coordinate, altitude: 90)
        let image = UIImage(named: "art.scnassets/pin.png")!
        let image3 = textToImage(drawText:"Son's Home", inImage:image, atPoint:CGPoint(x:0,y:0))
        
        let annotationNode = LocationAnnotationNode(location: location, image: image3)
        annotationNode.scaleRelativeToDistance = true
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 49.2651, longitude: -123.2506)
        let location1 = CLLocation(coordinate: coordinate1, altitude: 85)
        let image1 = UIImage(named: "art.scnassets/pin.png")!
        let image2 = textToImage(drawText:"STUFF", inImage:image1, atPoint:CGPoint(x:0,y:0))
        
        let annotationNode1 = LocationAnnotationNode(location: location1, image: image2)
        annotationNode1.scaleRelativeToDistance = true
        
        //        let text = SCNText(string: "Hello,World", extrusionDepth: 1)
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIColor.green
        //        text.materials = [material]
        //
        //        let textNode = SCNNode()
        //        textNode.position = SCNVector3(x:0,y:0,z:0)
        //        textNode.scale = SCNVector3(x:0.01,y:0.01,z:0.01)
        //        textNode.geometry = text
        
        //let annotationNode2 = LocationAnnotationNode(location: location, textNode: textNode)
        //annotationNode2.scaleRelativeToDistance = false
        
        //sceneLocationView.autoenablesDefaultLighting = true
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)
        //sceneLocationView.scene.rootNode.addChildNode(textNode)
        
        sceneLocationView.run()
    }
    
    var sceneLocationView = SceneLocationView()

    @IBOutlet var sceneView: ARSCNView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var alt = 0.0
    
    var yourName = "";
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.wtvr), userInfo: nil, repeats: true)

        
        yourName = "Parash Rahman (Brother In Law)"

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        
        

        
        view.addSubview(sceneLocationView)

        
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.green
        let textFont = UIFont(name: "Helvetica Bold", size: 20)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
    
        
        
        alt = lastLocation.altitude
        
        let url = URL(string: "http://52.233.39.60:5000/gps")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "{\"name\":\"\(yourName)\", \"lon\":\"\(lastLocation.coordinate.longitude)\", \"lat\":\"\(lastLocation.coordinate.latitude)\"}"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
