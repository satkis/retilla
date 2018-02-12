//
//  MainMap.swift
//  retilla
//
//  Created by satkis on 2/12/18.
//  Copyright © 2018 satkis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainMapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 5000
    
    //these will need to be downloaded from Firebase and here should be coordinates
    let addresses = [
    "Ozo g. 14, Vilnius 08200",
    "Verkių g. 29, Vilnius 09108",
    "Bow Bridge, New York, NY 10024, Jungtinės Valstijos"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locationAuthStatus()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
        
        
        for add in addresses {
            getPlaceMarkFromAddress(address: add)
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }


    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(location: loc)
            print("location loc: \(loc)")
            let lat = loc.coordinate.latitude
            let long = loc.coordinate.longitude
            
            print("latitude: \(lat)", "longitude: \(long)")
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemark, error) in
                if error != nil {
                    debugPrint("location error: \(error)")
                } else {
                    if let place = placemark?[0] {
                        print("administrativeArea: \(String(describing: place.administrativeArea))")
                        print("areasOfInterest: \(String(describing: place.areasOfInterest))")
                        print("country: \(String(describing: place.country))")
                        print("inlandWater: \(String(describing: place.inlandWater))")
                        print("locality: \(String(describing: place.locality))")
                        print("isoCountryCode: \(String(describing: place.isoCountryCode))")
                        print("name: \(String(describing: place.name))")
                        print("ocean: \(String(describing: place.ocean))")
                        print("postalCode: \(String(describing: place.postalCode))")
                        print("region: \(String(describing: place.region))")
                        print("subAdministrativeArea: \(String(describing: place.subAdministrativeArea))")
                        print("subLocality: \(String(describing: place.subLocality))")
                        print("subThoroughfare: \(String(describing: place.subThoroughfare))")
                        print("timeZone: \(String(describing: place.timeZone))")
                    }
                }
            })
        }
    }
    

    
    func createAnnotationforLocation(location: CLLocation) {
        let anot = Annotations(coordinate: location.coordinate)
        map.addAnnotation(anot)
    }
    
    func getPlaceMarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemark, error) in
            if let marks = placemark, marks.count > 0 {
                if let loc = marks[0].location {
                    //we have a valid location with coordinates
                    self.createAnnotationforLocation(location: loc)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
