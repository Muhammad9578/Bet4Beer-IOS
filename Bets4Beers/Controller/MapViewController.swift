//
//  MapViewController.swift
//  Bets4Beers
//
//  Created by iOS Dev on 16/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class MapViewController: UIViewController{

    @IBOutlet var addressNameLbl: UILabel!
    @IBOutlet var addressView: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var cursorBtn: UIButton!
    
    let currentLocation = LocationMO(with: [:])
    var latitude = 0.0
    var longitude = 0.0
    var selectedMarker: GMSMarker?
    var locationManager = CLLocationManager()
    var lat = [40.792148,40.268117,40.802616,41.070785,40.257691,41.201952,40.216285,39.89037,40.89422,40.931520,39.872830,40.672680,40.626182,40.216267,40.870932,40.799162,40.678299,40.913999,40.380731,39.485083]
    var long = [-73.880210,-74.328820,-74.379961,-73.590161,-73.880210,-74.781719,-74.010102,-74.925430,-74.698870,-74.025580,-75.045370,-74.201030,-74.259096,-74.010076,-74.180121,-74.058238,-74.195876,-74.050119,-74.388224,-74.583805]
    var name = ["Spring Lake Tap House","Bar code","Finn’s Corner","Mickey's Bar & Grill","Spring Lake Tap House","Ringside Lounge","Asbury Ale House Sports Bar & Grille","Chickie's and Pete's","Polo's Bar & Grill","Section 201","Time Out Sports Bar & Grill","Terminal One Sports Bar","Styles Inn Sports Bar & Grill","Hollywood Cafe & Sports Bar","Public House 46 Sports Bar & Grill","Plank Road Inn","The Lobby NJ","Miller's Ale House - Paramus","Ryan's Pub & Sports Bar","Tailgaters Sports Bar & Grille"]
    
    var addresses = ["","","660 Washington Ave, Brooklyn, NY 11238, United States","601 Riverside Ave #136, Lyndhurst, NJ 07071, United States","810 NJ-71, Spring Lake, NJ 07762, United States"," 475 Tonnelle Ave., Jersey City, NJ 07307, United States","531 Cookman Ave, Asbury Park, NJ 07712, United States","","50 NJ-183, Netcong, NJ 07857, United States","704 River Rd, New Milford, NJ 07646, United States","241 White Horse Pike, Barrington, NJ 08007, United States","566 Spring St, Elizabeth, NJ 07201, United States","305 N Stiles St, Linden, NJ 07036, United States","531 Cookman Ave, Asbury Park, NJ 07712, United States","1081 US-46, Clifton, NJ 07013, United States","1538 Paterson Plank Rd, Secaucus, NJ 07094, United States","821 Spring St, Elizabeth, NJ 07201, United States","270 NJ-4, Paramus, NJ 07652, United States","299 Spotswood Englishtown Rd, Monroe Township, NJ 08831, United States","337 W White Horse Pike, Egg Harbor City, NJ 08215, United State"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
//        self.locationManager.requestAlwaysAuthorization()
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        self.mapView.isMyLocationEnabled = true
    }
    
    func setUpView() {
        addressView.layer.cornerRadius = 3
        addressView.dropShadow()
        mapView.delegate = self
        addressView.isHidden = true
        var locations = [LocationMO]()
        for index in 0..<lat.count {
            let location = LocationMO(with: [:])
            location.latitude = lat[index]
            location.longitude = long[index]
            location.address = name[index]
            locations.append(location)
        }
        for single in locations {
            addMarker(at: single)
        }
        locationView.layer.cornerRadius = 3
        cursorBtn.addTarget(self, action: #selector(markerClick), for: .touchUpInside)
    }
    
    func addMarker(at location: LocationMO?, isCurrent: Bool = false) {
        let position = CLLocationCoordinate2D(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
        let marker = GMSMarker(position: position)
        marker.title = "\(location?.address ?? "")"
        marker.map = mapView
        if isCurrent {
            marker.icon = #imageLiteral(resourceName: "myLocation")
        }else {
            marker.icon = #imageLiteral(resourceName: "cocktail (2)")
        }
        let camera = GMSCameraPosition.camera(withLatitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0, zoom: 8.0)
        mapView?.camera = camera
        mapView?.animate(to: camera)
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // select new marker and make green
        self.mapView.camera = GMSCameraPosition(latitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 8.0)
        for index in 0..<addresses.count {
            if marker.position.latitude == lat[index],
                marker.position.longitude == long[index] {
                if addresses[index] == "" {
                    addressView.isHidden = true
                }else {
                    addressView.isHidden = false
                    addressNameLbl.text = addresses[index]
                }
                self.latitude = marker.position.latitude
                self.longitude = marker.position.longitude
                cursorBtn.isHidden = false
                locationView.isHidden = false
                locationImg.isHidden = false
                marker.icon = #imageLiteral(resourceName: "cocktail (2)")
            }else if marker.position.latitude == currentLocation.latitude,
                marker.position.longitude == currentLocation.longitude {
                addressView.isHidden = false
                addressNameLbl.text = "My Current Location!"
                marker.icon = #imageLiteral(resourceName: "myLocation")
            }
        }
        return false
    }
    
    
    @objc func markerClick() {
        guard let url = URL(string:"http://maps.apple.com/?daddr=\(latitude),\(longitude)") else { return }
        UIApplication.shared.open(url)
    }
}


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = manager.location
        currentLocation.latitude = location?.coordinate.latitude ?? 0.0
        currentLocation.longitude = location?.coordinate.longitude ?? 0.0
        currentLocation.address = "My Current Location"
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        self.mapView?.animate(to: camera)
        addMarker(at: currentLocation, isCurrent: true)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
}
