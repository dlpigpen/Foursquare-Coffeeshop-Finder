//
//  CFViewController.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit
import MapKit

class CFViewController: UIViewController, MKMapViewDelegate, SearchViewDelegate, UISearchResultsUpdating {
    let kAnnotationViewIdentifier = "AnnotationViewIdentifier"
    let kCFAnnotationDetailSegue = "CFAnnotationDetailSegue"
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var locationBarButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    var cfsArray: NSMutableArray!
    var CFHelper: CFNetworkHelper!
    var search: SearchController!
    var searchControl: UISearchController!
    
    var locationManager: CLLocationManager!
    var selectedAnnotation: CFMapAnnotation!
    var firstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init store the annotations
        self.cfsArray = NSMutableArray()
        self.initLocationManager()
        
        // Navigation Bar Title
        self.title = "Four Square Coffee Shop Finder"
        
        // Add UIBarButtonItem events
        self.searchBarButton.target = self
        self.searchBarButton.action = #selector(self.searchBarButtonPressed)
        self.locationBarButton.target = self
        self.locationBarButton.action = #selector(self.locationBarButtonPressed)
        
        // Map View
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        // CF Helper
        self.CFHelper = CFNetworkHelper()
        firstTime = true
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if firstTime && self.mapView.isEqual(mapView) {
            self.centerMapUserCurrentLocation(userLocation)
            self.updateNearbyCFsAtCoordinate(userLocation.coordinate)
        }
    }
    
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !firstTime && self.mapView.isEqual(mapView) {
            self.updateNearbyCFsAtCoordinate(self.mapView.centerCoordinate)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var customPinView: CFPinAnnotationView?
        if !annotation.isMemberOfClass(MKUserLocation.self) {
            customPinView = (self.mapView.dequeueReusableAnnotationViewWithIdentifier(kAnnotationViewIdentifier) as? CFPinAnnotationView)
            if customPinView == nil {
                customPinView = CFPinAnnotationView(annotation: annotation, reuseIdentifier: kAnnotationViewIdentifier)
                customPinView!.animatesDrop = true
                customPinView!.canShowCallout = true
                let detailButton = UIButton(type: .DetailDisclosure)
                detailButton.setImage(UIImage(named: "rightGrayArrow")!.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
                detailButton.addTarget(self, action: #selector(self.annotationCalloutViewPressed), forControlEvents: .TouchUpInside)
                customPinView!.rightCalloutAccessoryView = detailButton
            }
            
            return customPinView!
        } else {
            return .None
        }
    }
    
    
    // MARK: - Actions
    
    func searchBarButtonPressed(button: UIBarButtonItem) {
        // search event
        self.search = SearchController()
        self.search.delegate = self
        self.searchControl = UISearchController(searchResultsController: search!)
        self.searchControl.searchResultsUpdater = self
        self.searchControl.hidesNavigationBarDuringPresentation = false
        self.searchControl.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.navigationController!.presentViewController(searchControl!, animated: true, completion: { _ in })
    }
    
    func locationBarButtonPressed(button: UIBarButtonItem) {
        self.centerMapUserCurrentLocation(self.mapView.userLocation)
        self.updateNearbyCFsAtCoordinate(self.mapView.userLocation.coordinate)
    }
    
    func annotationCalloutViewPressed(calloutButton: UIButton) {
        let pinAnnotationView = (calloutButton.superviewOfType() as? CFPinAnnotationView)
        if pinAnnotationView != nil {
            selectedAnnotation = pinAnnotationView!.annotation as! CFMapAnnotation
            self.performSegueWithIdentifier(kCFAnnotationDetailSegue, sender: self)
        }
    }
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == kCFAnnotationDetailSegue) {
            let viewController = (segue.destinationViewController as! CFAnnotationDetailViewController)
            viewController.annotation = selectedAnnotation!
            viewController.nearAnnotations = (self.annotationListWithout(selectedAnnotation!, distanceLessThan: Constants.sharedInstance.ONE_MILE))
            viewController.userLocation = self.mapView.userLocation.coordinate
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: nil, action: nil)
        }
    }
    // MARK: - MapView update
    
    func centerMapUserCurrentLocation(userLocation: MKUserLocation) {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func updateNearbyCFsAtCoordinate(coordinate: CLLocationCoordinate2D) {
        self.CFHelper.getNearbyCFsAtCoordinate(coordinate) { (CFsArray, error) in
            if (error == nil) {
                self.updateMapWithResponse(CFsArray)
            }

        }
    }
    
    func updateMapWithResponse(CFsArray: NSArray) {
        var region: MKCoordinateRegion
        if firstTime {
            firstTime = false
            region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            region.center = self.mapView.userLocation.coordinate
        }
        else {
            region = self.mapView.region
        }
        for i in 0..<CFsArray.count {
            
            let CF = CFsArray[i]
            let identifier = (CF["id"] as! String)
            let latitud: Double = Double((CF["latitud"] as! String))!
            let longitud: Double = CDouble((CF["longitud"] as! String))!
            let coordinate = CLLocationCoordinate2DMake(latitud, longitud)
            
            if !self.annotationIdentifierInMapView(identifier) && self.coordinate(coordinate, inRegion: region) {
                
                let name = (CF["name"] as! NSString)
                let address = (CF["address"] as! NSString)
                
                let mapAnnotation = CFMapAnnotation(coordinate: coordinate, title: name, subtitle: address)
                mapAnnotation.identifier = identifier as NSString
                mapAnnotation.distance = CF["distance"] as? NSNumber
                mapAnnotation.formattedAddress = CF["formattedAddress"] as? NSString
                mapAnnotation.formattedPhone = CF["formattedPhone"] as? NSString
                mapAnnotation.categoryIconURL = CF["categoryIconURL"] as? NSString
                mapAnnotation.categoryName = CF["categoryName"] as? NSString
                if let categoryIcon = mapAnnotation.categoryIconURL {
                    self.CFHelper.getImageNSDataFromURL(categoryIcon as String, withCompletionHandler: {(data: NSData) -> Void in
                        mapAnnotation.categoryIcon = UIImage(data: data)!.imageWithRenderingMode(.AlwaysOriginal)
                    })
                }
                
                if self.cfsArray.containsObject(mapAnnotation) == false  {
                    self.cfsArray.addObject(mapAnnotation)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                   self.mapView.addAnnotation(mapAnnotation)
                }
                
            }
        }
    }
    // MARK: - Helpers
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestWhenInUseAuthorization()
        
        locationManager!.startUpdatingLocation()
    }
    
    func coordinate(coord: CLLocationCoordinate2D, inRegion region: MKCoordinateRegion) -> Bool {
        let center = region.center
        let span = region.span
        var result = true
        result = result && cos((center.latitude - coord.latitude) * M_PI / 180.0) > cos(span.latitudeDelta / 2.0 * M_PI / 180.0)
        result = result && cos((center.longitude - coord.longitude) * M_PI / 180.0) > cos(span.longitudeDelta / 2.0 * M_PI / 180.0)
        return result
    }
    
    func annotationIdentifierInMapView(identifier: String) -> Bool {
        let annotations = self.mapView.annotations as NSArray
        for index in 0..<annotations.count {
            let ann = annotations[index]
            if ann is MKUserLocation  {
                return false
            } else if ann is CFMapAnnotation {
                let cfmap = ann as! CFMapAnnotation
                if identifier == cfmap.identifier! {
                    return true
                }
            }
        }
        return false
    }
    
    func annotationListWithout(annotation: CFMapAnnotation, distanceLessThan distance: Int) -> [AnyObject] {
        let mapAnns = self.mapView.annotations.filter { (ann) -> Bool in
            if ann is CFMapAnnotation {
                return true
            }
            return false
        }
        let predicate = NSPredicate(format: "identifier != %@ AND distance <= %d", annotation.name, distance)
        let descriptor = NSSortDescriptor(key: "name", ascending: true)
        return ((mapAnns as NSArray).filteredArrayUsingPredicate(predicate) as NSArray).sortedArrayUsingDescriptors([descriptor])
    }
    
    // MARK: - Search Delegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let string = searchController.searchBar.text
        if searchController.searchResultsController != nil {
            let search = (searchController.searchResultsController as! SearchController)
            let filtered = (self.cfsArray as NSArray).filteredArrayUsingPredicate(NSPredicate(format: "name CONTAINS[cd] %@", string!))
            search.arrData = filtered
            search.tableView.reloadData()
        }
    }
    
    func didSelectRow(cfDictionay: CFMapAnnotation) {
        selectedAnnotation = cfDictionay
        self.searchControl.active = false
        self.definesPresentationContext = false
        self.performSegueWithIdentifier(kCFAnnotationDetailSegue, sender: self)
    }
    
}