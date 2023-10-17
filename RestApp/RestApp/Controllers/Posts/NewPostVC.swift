//
//  NewPostVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 17.10.23.
//

import UIKit
import SwiftyJSON
import Alamofire

final class NewPostVC: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
    
    var user: User?
    
    @IBAction func postURLSession() {
        if let userId = user?.id,
           let title = titleTF.text,
           let body = bodyTV.text,
           let url = ApiConstants.postsURL {
            
            /// Setup request
            var request = URLRequest(url: url)
            
            /// HEADER
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            /// BODY
            let postBodyJSON: [String: Any] = [
                "userId": userId,
                "title": title,
                "body": body
            ]
            let httpBody = try? JSONSerialization.data(withJSONObject: postBodyJSON)
            request.httpBody = httpBody
            
            /// create dataTask and send new Post
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let data = data {
                    print(data)
                    let json = JSON(data)
                    print(json)
                    let userId = json["userId"]
                    let title = json["title"]
                    let body = json["body"]
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }.resume()
            
        }
    }
    
    @IBAction func postAlamofire() {
        if let userId = user?.id,
           let title = titleTF.text,
           let body = bodyTV.text,
           let url = ApiConstants.postsURL {
            
            let parameters: Parameters = [
                "userId": userId,
                "title": title,
                "body": body
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .response { [weak self] response in
                    /// тут мы уже в главном потоке
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    switch response.result {
                    case .success(let data):
                        print(data ?? "")
                        self?.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error)
                        
                    }
                }
        }
    }
}
