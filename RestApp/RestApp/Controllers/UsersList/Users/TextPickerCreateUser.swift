//
//  TextPickerCreateUser.swift
//  RestApp
//
//  Created by Alexandr Filovets on 16.10.23.
//

import UIKit

final class TextPickerCreateUser {
    
    func showPicker(in viewController: UIViewController, completion: @escaping ((User?) -> Void)) {
        let alertController = UIAlertController(title: "Create New User", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name (required)"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "User Name (required)"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Email (required)"
            textField.keyboardType = .emailAddress
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Phone"
            textField.keyboardType = .phonePad
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Website"
            textField.keyboardType = .URL
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Street"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Suite"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "City"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Zipcode"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Latitude"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Longitude"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Company Name"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Catch Phrase"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "BS"
        }
        
        let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in
            let name = alertController.textFields?[0].text
            let username = alertController.textFields?[1].text
            let email = alertController.textFields?[2].text
            let phone = alertController.textFields?[3].text
            let website = alertController.textFields?[4].text
            let street = alertController.textFields?[5].text
            let suite = alertController.textFields?[6].text
            let city = alertController.textFields?[7].text
            let zipcode = alertController.textFields?[8].text
            let latitude = alertController.textFields?[9].text
            let longitude = alertController.textFields?[10].text
            let companyName = alertController.textFields?[11].text
            let catchPhrase = alertController.textFields?[12].text
            let bs = alertController.textFields?[13].text
            
            let address = Address(street: street, suite: suite, city: city, zipcode: zipcode, geo: Geo(lat: latitude, lng: longitude))
            let company = Company(name: companyName, catchPhrase: catchPhrase, bs: bs)
            
            let user = User(id: 0, name: name, username: username, email: email, phone: phone, website: website, address: address, company: company)
            
            completion(user)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
