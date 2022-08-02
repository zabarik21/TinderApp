//
//  LocationService.swift
//  TinderApp
//
//  Created by Timofey on 27/7/22.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

class LocationService: NSObject {
  
  static let shared = LocationService()
  
  private let bag = DisposeBag()
  
  private let locationStatusSubject = PublishRelay<CLAuthorizationStatus>()
  
  private let locationSubject = PublishSubject<Location>()
  
  public var locationObservable: Observable<Location> {
    return locationSubject.asObservable()
  }
  
  private override init() {
    super.init()
    locationManager.delegate = self
    setupObserver()
  }
  
  func getDistance(fst: CLLocation, snd: Coordinates) -> Int? {
    guard let lat = Double(snd.latitude),
          let lon = Double(snd.longitude) else { return nil }
    let sndLocation = CLLocation(latitude: lat, longitude: lon)
    return Int(fst.distance(from: sndLocation) / 1000)
  }
  
  private func setupObserver() {
    locationStatusSubject
      .subscribe(on: MainScheduler.instance)
      .subscribe(onNext: { status in
        switch status {
        case .notDetermined, .restricted, .denied:
          break
        case .authorizedAlways, .authorizedWhenInUse:
          self.getCurrentLocation()
        @unknown default:
          print("Uknown")
        }
      })
      .disposed(by: bag)
  }
  
  private let locationManager = CLLocationManager()
  
  func requestLocation() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func getCurrentLocation() {
    locationManager.requestLocation()
  }
  
}

extension LocationService: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    locationStatusSubject.accept(manager.authorizationStatus)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard !locations.isEmpty else { return }
    let location = locations.first!
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    DispatchQueue.main.async { [weak self] in
      CLGeocoder().reverseGeocodeLocation(location) { [weak self] placeMark, error in
        var city: String?
        if let error = error {
          print(error)
        } else {
          city = placeMark?.first?.locality
        }
        let userLocation = Location(
          city: city ?? "Hided",
          coordinates: Coordinates(
            latitude: "\(latitude)",
            longitude: "\(longitude)"))
        self?.locationSubject.onNext(userLocation)
      }
    }
    
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
