//
//  ViewController.swift
//  essaidev
//
//  Created by Admin on 18/04/2018.
//

import UIKit
import Mapbox
import Firebase

class MapController: UIViewController {
    var mapView: MGLMapView!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.allowsTilting = false
        mapView.allowsRotating = false
        mapView.zoomLevel = 10
        mapView.minimumZoomLevel = 1
        mapView.delegate = self
        
        //mapView.setUserTrackingMode(.follow, animated: true)
        
        view.addSubview(mapView)
    }
}

extension MapController: MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        /*ref.child("user_locations")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    let childValue = childSnapshot.value as? NSDictionary
                    let latitude = childValue?["lat"] as? NSNumber ?? 0
                    let longitude = childValue?["long"] as? NSNumber ?? 0
                    let annotation = MGLPointAnnotation()
                    
                    print(CLLocationDegrees(truncating: latitude))
                    
                    annotation.coordinate =  CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
                    
                    mapView.addAnnotation(annotation)
                }
            }) { (error) in
                print(error.localizedDescription)
            }*/
    /*}
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        if let annotations = mapView.annotations {
             //mapView.removeAnnotations(annotations)
        }*/
        
        let nwPoint = CGPoint(x: 0, y: 0)
        let sePoint = CGPoint(x: mapView.frame.size.width, y: mapView.frame.size.height)
        let nePoint = CGPoint(x: mapView.frame.size.width, y: 0)
        let swPoint = CGPoint(x: 0, y: mapView.frame.size.height)
        
        let nw = mapView.convert(nwPoint, toCoordinateFrom: mapView)
        let se = mapView.convert(sePoint, toCoordinateFrom: mapView)
        let ne = mapView.convert(nePoint, toCoordinateFrom: mapView)
        let sw = mapView.convert(swPoint, toCoordinateFrom: mapView)
        
        let bounds = MGLCoordinateBounds(sw: sw, ne: ne)
        
        /*ref.child("user_locations")
            .queryOrdered(byChild: "lat")
            .queryStarting(atValue: nw.latitude)
            .queryEnding(atValue: se.latitude)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    let childValue = childSnapshot.value as? NSDictionary
                    
                    print(childValue ?? nil)
                }
        }) { (error) in
            print(error.localizedDescription)
        }*/
        
        //let size = 90 * mapView.zoomLevel
        
        let cameraLatNw = Int(nw.latitude)
        let cameraLatSw = Int(sw.latitude)
        let cameraLongNw = Int(nw.longitude)
        let cameraLongSw = Int(sw.longitude)
        
        print(cameraLongNw, cameraLongSw)
        
        for lat in cameraLatNw...cameraLatSw {
            for long in cameraLongSw...cameraLongSw {
                var coordinates = [
                    CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long)),
                    CLLocationCoordinate2D(latitude: Double(lat + 1), longitude: Double(long)),
                    CLLocationCoordinate2D(latitude: Double(lat + 1), longitude: Double(long + 1)),
                    CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long + 1))
                ]
                
                let shape = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
                
                //shape.setValue(true, forKey: "isEven")
                
                mapView.addAnnotation(shape)
            }
        }
        
        //return true
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.2
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .red
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1)
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // For better performance, always try to reuse existing annotations.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "placeholder")
        
        // If there is no reusable annotation image available, initialize a new one.
        if(annotationImage == nil) {
            annotationImage = MGLAnnotationImage(image: UIImage(named: "placeholder")!, reuseIdentifier: "placeholder")
        }
        
        return annotationImage
    }
}

