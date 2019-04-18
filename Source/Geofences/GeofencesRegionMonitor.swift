//
//  GeofencesRegionMonitor.swift
//  Alamofire
//
//  Created by Rodolfo Pujol Luna on 28/02/19.
//

import CoreLocation
import Foundation
import PromiseKit

protocol GeofencesRegionMonitorDelegate: class {
    func didChangeStatus(isInRange: Bool)
}

class GeofencesRegionMonitor {
 
    var timer: Timer?
    var isInRange = false
    let scanInterval = 90.0
    let radius = 5.0
    
    func startMonitoring() -> Promise<Void> {
        
        timer = Timer.scheduledTimer(withTimeInterval: scanInterval, repeats: true) { _ in
            _ = LocationManager.currentLocation.done { location in
                ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .inrangeRequest, location: location))
                let request = GeofenceRegionRequest(lat: location.coordinate.latitude, lng: location.coordinate.longitude, radius: self.radius)
                _ = self.requestRegions(forPosition: request)
            }
        }
        
        return firstly {
            LocationManager.currentLocation
        }.then { location -> Promise<Void> in
                ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .inrangeRequest, location: location))
                let firstRequest = GeofenceRegionRequest(lat: location.coordinate.latitude, lng: location.coordinate.longitude, radius: self.radius)
                return self.requestRegions(forPosition: firstRequest)
        }
    }
    
    func requestRegions(forPosition region: GeofenceRegionRequest) -> Promise<Void> {
        return firstly { GeofencesServices.getGeofenceRegions(request: region) }.done { result in
            guard let totalCount = result.totalCount else { return }
            ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .inrangeResponse, forCampaign: "found \(String(totalCount))"))
            result.data?.forEach { region in
                self.registerGeofence(geofence: region)
            }
            
        }.done {
                
        }
    }
    
    func registerGeofence(geofence: Region) {
        guard let center = geofence.center, let geofenceId = geofence.geofenceId else { return }
        
        let locationCenter = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng)
        let region = CLCircularRegion(center: locationCenter, radius: center.radius, identifier: String(geofenceId))
        region.notifyOnEntry = true
        region.notifyOnExit = true
        LocationManager.startMonitoring(forRegion: region)
    }
}
