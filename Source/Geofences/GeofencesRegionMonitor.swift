//
//  GeofencesRegionMonitor.swift
//  Alamofire
//
//  Created by Rodolfo Pujol Luna on 28/02/19.
//

import CoreLocation
import Foundation

protocol GeofencesRegionMonitorDelegate: class {
    func didChangeStatus(isInRange: Bool)
}

class GeofencesRegionMonitor {
    
    var timer: Timer?
    var isInRange = false
    let scanInterval = 90.0
    let radius = 5.0
    
    func startMonitoring() {
        
        _ = LocationManager.currentLocation.done { location in
            ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .inrangeRequest, location: location))
            let firstRequest = GeofenceRegionRequest(lat: location.coordinate.latitude, lng: location.coordinate.longitude, radius: self.radius)
            self.requestRegions(forPosition: firstRequest)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: scanInterval, repeats: true) { _ in
            _ = LocationManager.currentLocation.done { location in
                ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .inrangeRequest, location: location))
                let request = GeofenceRegionRequest(lat: location.coordinate.latitude, lng: location.coordinate.longitude, radius: self.radius)
                self.requestRegions(forPosition: request)
            }
        }
    }
    
    func requestRegions(forPosition region: GeofenceRegionRequest) {
        _ = GeofencesServices.getGeofenceRegions(request: region).done { result in
            guard let totalCount = result.totalCount else { return }
            ConsolePresenter.shared.sendMessage(content: ConsoleContent(message: .inrangeResponse, forCampaign: "found \(String(totalCount))"))
            result.data?.forEach { region in
                self.registerGeofence(geofence: region)
            }
        }.catch { error in
                Log.print(title: "GeofencesServices - Error", message: error.localizedDescription)
        }
    }
    
    func registerGeofence(geofence: Region) {
        guard let center = geofence.center, let campaignId = geofence.campaignId else { return }
        
        let locationCenter = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng)
        let region = CLCircularRegion(center: locationCenter, radius: center.radius, identifier: String(campaignId))
        region.notifyOnEntry = true
        region.notifyOnExit = true
        LocationManager.startMonitoring(forRegion: region)
    }
}
