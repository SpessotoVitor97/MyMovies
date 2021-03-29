//
//  MapViewController.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 26/03/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //*************************************************
    // MARK: - Properties
    //*************************************************
    var locationManager = CLLocationManager()
    
    //*************************************************
    // MARK: - Outlets
    //*************************************************
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        requestAuthorization()
    }
    
    //*************************************************
    // MARK: - Navigation
    //*************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SiteViewController,
           let sender = sender as? String {
            viewController.url = sender
        }
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    private func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func showRoute(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        let placeMarkUserLocation = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        let placeMarkDestination = MKPlacemark(coordinate: destination)
        
        request.source = MKMapItem(placemark: placeMarkUserLocation)
        request.destination = MKMapItem(placemark: placeMarkDestination)
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                guard let response = response,
                      let route = response.routes.first else { return }
                print("Nome:", route.name, "- distância:", route.distance, "- duração:", route.expectedTravelTime)
                
                for step in route.steps {
                    print("Em", step.distance, "metros, ", step.instructions)
                }
                
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlays([route.polyline], level: .aboveRoads)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

//*************************************************
// MARK: - UISearchBarDelegate
//*************************************************
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else { return }
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

//*************************************************
// MARK: - MKMapViewDelegate
//*************************************************
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
              let name = annotation.title else { return }
        
        let alert = UIAlertController(title: name, message: "O que deseja fazer?", preferredStyle: .actionSheet)
        if let subtitle = annotation.subtitle,
           let url = subtitle {
            let urlAction = UIAlertAction(title: "Acessar site", style: .default) { (action) in
                self.performSegue(withIdentifier: "webSegue", sender: url)
            }
            let routeAction = UIAlertAction(title: "Traçar rota", style: .default) { (action) in
                self.showRoute(to: annotation.coordinate)
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alert.addAction(urlAction)
            alert.addAction(routeAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            
            let render = MKPolylineRenderer(overlay: overlay)
            render.lineWidth = 8.0
            render.strokeColor = .blue
            
            return render
            
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
