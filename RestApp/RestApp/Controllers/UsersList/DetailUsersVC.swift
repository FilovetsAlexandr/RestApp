//
//  DetailUsersVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 12.10.23.
//

import UIKit
import MapKit

final class DetailUsersVC: UIViewController {
    
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var userNameLbl: UILabel!
    @IBOutlet private weak var emailLbl: UILabel!
    @IBOutlet private weak var phoneLbl: UILabel!
    @IBOutlet private weak var websiteLbl: UILabel!
    @IBOutlet private weak var adressLbl: UILabel!
    
    var detailUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetail(user: detailUser)
    }
    
    @IBAction func openMapsButtonTapped(_ sender: UIButton) { openMapsForUserLocation() }
    
    private func openMapsForUserLocation() {
        if let user = detailUser,
           let latitudeString = user.address?.geo?.lat,
           let longitudeString = user.address?.geo?.lng,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString)
        {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = user.name
            mapItem.openInMaps(launchOptions: nil)
        }
    }
    private func setDetail(user: User?) {
        if let user = user {
            nameLbl.text = user.name
            userNameLbl.text = user.username
            emailLbl.text = user.email
            phoneLbl.text = user.phone
            websiteLbl.text = user.website
            if let city = user.address?.city,
               let street = user.address?.street,
               let suite = user.address?.suite,
               let zipcode = user.address?.zipcode {
                adressLbl.text = "\(city)\n\(street)\n\(suite)\n\(zipcode)"
            } else {
                adressLbl.text = "Unknown"
            }
        }
    }
}
