//
//  LocationSearchController.swift
//  Weather
//
//  Created by Andrew. on 24/09/2018.
//  Copyright © 2018 A Code Guy. All rights reserved.
//

import UIKit
import MapKit
import Toast_Swift

class LocationSearchController: UITableViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        locationSearchBar.delegate = self
       
    }
    
    // MARK: UISearchBar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        locationSearchBar.endEditing(true)
        locationSearchBar.resignFirstResponder()
        
        return true
    }
    
    // MARK: UITableView methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchResults[indexPath.row].title
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            if error != nil {
                
                
            } else {
                
                guard let response = response else {
                    
                    return
                }
                
                for location in response.mapItems {
                    
                    let lat = location.placemark.coordinate.latitude
                    let lon = location.placemark.coordinate.longitude
                    
                    print("lat: \(lat), long: \(lon)")
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationResultCell", for: indexPath)
        
        cell.textLabel?.text = searchResults[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // MKLocalSearch
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        tableView.reloadData()
    }
    
}
