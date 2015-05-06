//
//  EventMapViewController.swift
//  MW
//
//  Created by Joseph Canero on 4/13/15.
//  Copyright (c) 2015 iOS Team. All rights reserved.
//

import UIKit
import MapKit

class EventMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var eventMap: MKMapView!
    let regionRadius:CLLocationDistance = 1000
    var eventManager: EventsManager?
    
    override func viewDidLoad() {
        if let latitude = MusiciansWanted.latitude {
            if let longitude = MusiciansWanted.longitude {
                let initialLocation = CLLocation(latitude: MusiciansWanted.latitude!, longitude: MusiciansWanted.longitude!)
                
                centerMapOnLocation(initialLocation)
            }
        }
        eventMap.delegate = self
        
        for event in eventManager!.event {
            var mapAnnotation = Event(title: event.eventName, locationName: event.eventLocation, id: event.eventId, icon: event.eventPicture!, coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
            dispatch_async(dispatch_get_main_queue()) {
                self.eventMap.addAnnotation(mapAnnotation)
            }
        }
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        eventMap.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Event {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        let annotation = view.annotation as? Event
        nextView.id = annotation?.id
        nextView.icon = annotation?.icon
        nextView.controller = "maps"
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
