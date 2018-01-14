//
//  ViewController.swift
//  AlzheimeR
//
//  Created by Gary Dhillon on 2018-01-13.
//

import UIKit
import SceneKit
import ARKit

import ARCL
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    var sceneLocationView = SceneLocationView()

    @IBOutlet var sceneView: ARSCNView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var alt = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        
        let coordinate = CLLocationCoordinate2D(latitude: 49.26225, longitude: -123.2452)
        let location = CLLocation(coordinate: coordinate, altitude: 85)
        let image = UIImage(named: "art.scnassets/pin.png")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 49.2651, longitude: -123.2506)
        let location1 = CLLocation(coordinate: coordinate1, altitude: 85)
        let image1 = UIImage(named: "art.scnassets/pin.png")!
        
        let annotationNode1 = LocationAnnotationNode(location: location1, image: image1)
        annotationNode1.scaleRelativeToDistance = true
        
        let label = UILabel(frame: .zero)
        label.textColor = .yellow
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Hello, world"
        label.sizeToFit()
        
        UIGraphicsBeginImageContextWithOptions(label.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { exit(0) }
        label.layer.render(in: context)
        let image3 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let annotationNode2 = LocationAnnotationNode(location: location1, image: image3!)
        annotationNode2.scaleRelativeToDistance = false
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode1)
        sceneLocationView.run()

        
        view.addSubview(sceneLocationView)

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
    
        alt = lastLocation.altitude
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
