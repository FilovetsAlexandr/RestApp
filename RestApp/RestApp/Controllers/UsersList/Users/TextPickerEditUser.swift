//
//  TextPickerEditUser.swift
//  RestApp
//
//  Created by Alexandr Filovets on 16.10.23.
//

import UIKit

final class TextPickerEditUser {
    func showPicker(for user: User, in viewController: UIViewController, completion: @escaping ((User?) -> Void)) {
        let alertController = UIAlertController(title: "Edit User", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name (required)"
            textField.text = user.name
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Username (required)"
            textField.text = user.username
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Email (required)"
            textField.keyboardType = .emailAddress
            textField.text = user.email
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Phone"
            textField.keyboardType = .phonePad
            textField.text = user.phone
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Website"
            textField.keyboardType = .URL
            textField.text = user.website
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Street"
            textField.text = user.address?.street
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Suite"
            textField.text = user.address?.suite
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "City"
            textField.text = user.address?.city
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Zipcode"
            textField.text = user.address?.zipcode
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Latitude"
            textField.text = user.address?.geo?.lat
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Longitude"
            textField.text = user.address?.geo?.lng
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Company Name"
            textField.text = user.company?.name
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Catch Phrase"
            textField.text = user.company?.catchPhrase
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "BS"
            textField.text = user.company?.bs
        }
        
        let actionOk = UIAlertAction(title: "Save", style: .default) { _ in
            let updatedUser = User(id: user.id, 
                                   name: alertController.textFields?[0].text ?? "",
                                   username: alertController.textFields?[1].text ?? "",
                                   email: alertController.textFields?[2].text ?? "",
                                   phone: alertController.textFields?[3].text ?? "",
                                   website: alertController.textFields?[4].text ?? "",
                                   address: Address(
                                    street: alertController.textFields?[5].text,
                                    suite: alertController.textFields?[6].text,
                                    city: alertController.textFields?[7].text,
                                    zipcode: alertController.textFields?[8].text,
                                    geo: Geo(
                                        lat: alertController.textFields?[9].text,
                                        lng: alertController.textFields?[10].text)),
                                   company: Company(
                                    name: alertController.textFields?[11].text,
                                    catchPhrase: alertController.textFields?[12].text,
                                    bs: alertController.textFields?[13].text))
            completion(updatedUser)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in completion(nil) }
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
