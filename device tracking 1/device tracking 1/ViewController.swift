//
//  ViewController.swift
//  device tracking 1
//
//  Created by Saikiran Komatineni on 1/19/19.
//  Copyright © 2019 saikiran. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate{

    var timer = Timer()
    
    var totalBots = 100
    var shortestDist = 0.0
    var shortestBot = 0
    
    let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.midX - 100, y: UIScreen.main.bounds.height - 150, width: 200, height: 80))
    
    var flag = false
    var locationManager = CLLocationManager()
    
    var ref: DocumentReference! = nil
    var db: Firestore!
    
    var localLat: [CLLocationDegrees] = []
    var localLong: [CLLocationDegrees] = []
    var difference: [Double] = []
    
    var currentLoc: [String: CLLocationDegrees] = ["latitude": 0.0,"longitude": 0.0]
    
    @IBAction func help_button(_ sender: Any) {
        print("button pressed")
        
        self.button.alpha = 0.2
    }
    
    @objc func touchUP(){
        print("button released...")
        self.button.alpha = 1
        
        findDistance()
        print("shortest Bot", shortestBot)
        
        db.collection("bots").document(String(shortestBot)).setData([
            "latitude": localLat[shortestBot],
            "longitude": localLong[shortestBot],
            "safety": true,
            "bot request": true
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    
    @objc func findDistance() {
        var tempLat = 0.0
        var tempLong = 0.0
        for i in 1...self.totalBots {
            tempLat = self.currentLoc["latitude"]! - self.localLat[i-1]
            tempLong = self.currentLoc["longitude"]! - self.localLong[i-1]
            let a = pow((sin(tempLat/2)),2) + cos(self.currentLoc["latitude"]!) * cos(self.localLat[i-1]) * pow((sin(tempLong/2)),2)
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            let d = 6371000 * c
            difference.append(d)
        }
        shortestDist = difference.min() ?? 10.0
        for i in 1...self.totalBots {
            if difference[i-1] == shortestDist {
                shortestBot = i-1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.process_timer), userInfo: nil, repeats: true)
        setupUser()
        button_handling()
        db = Firestore.firestore()
    }
    
    @objc func process_timer() {
        collectData()
        loadMap(latitude: self.currentLoc["latitude"]!, longitude: self.currentLoc["longitude"]!, userTrue: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectData()
    }
    
    @objc func collectData() {
        for i in 1...self.totalBots {
            db.collection("bots").document(String(i)).addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    print("Current data: \(data["latitude"]!)")
                    self.localLat.append(data["latitude"] as! CLLocationDegrees)
                    self.localLong.append(data["longitude"] as! CLLocationDegrees)
            }
        }
    }
    
    @objc func databaseSetup() {
        // Add a new document with a generated ID
        for i in 1...self.totalBots {
            var random_number = Double.random(in: -1.0 ..< 1.0)
            let newLat: CLLocationDegrees = currentLoc["latitude"]! + random_number
            random_number = Double.random(in: -1.0 ..< 1.0)
            let newLong: CLLocationDegrees = currentLoc["longitude"]! + random_number
            
            // Add a new document in collection "cities"
            db.collection("bots").document(String(i)).setData([
                "latitude": newLat,
                "longitude": newLong,
                "safety": true,
                "bot request": false
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        currentLoc["latitude"] = latitude
        currentLoc["longitude"] = longitude

        if flag == false{
            //databaseSetup()
            flag = true
        }
        
        //loadMap(latitude: latitude, longitude: longitude, userTrue: true)
    }
    
    @objc func setupUser() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func button_handling() {
        
        button.setTitle("HELP!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: button.frame.height * 0.4)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = self.button.frame.size.height/2
        button.addTarget(self, action: #selector(help_button(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(touchUP), for: .touchUpInside)
        self.view.insertSubview(button, aboveSubview: self.view)
        
    }
    
    
    @objc func loadMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees, userTrue: Bool) { //Display the specific location on the map
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if userTrue {
            marker.icon = UIImage(named: "placeholder.png")
        }
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        for i in 1...self.totalBots {
            let position = CLLocationCoordinate2D(latitude: localLat[i-1], longitude: localLong[i-1])
            let marker2 = GMSMarker(position: position)
            marker2.title = String(i)
            marker2.map = mapView
        }
        
        
        self.view .layoutIfNeeded()
        
        self.view.insertSubview(button, aboveSubview: self.view)
        
    }

}

