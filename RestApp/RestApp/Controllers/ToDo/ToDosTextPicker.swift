//
//  ToDosTextPicker.swift
//  RestApp
//
//  Created by Alexandr Filovets on 22.10.23.
//
import UIKit

final class ToDosTextPicker {
    func showPicker(in viewController: UIViewController, text: String, completion: @escaping ((String) -> Void)) {
        let alertController = UIAlertController(title: "Enter the name of the task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = text
        }
        
        let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in
            if let text = alertController.textFields?[0].text, !text.isEmpty {
                completion(text)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        viewController.present(alertController, animated: true)
    }
}
