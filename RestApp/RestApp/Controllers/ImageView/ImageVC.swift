//
//  ImageVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 11.10.23.
//

import UIKit

final class ImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let imageURL = "https://img.badfon.ru/original/6000x4000/1/e9/arizona-horseshoe-bend-river-1468.jpg"
    private let imageURL2 = "https://w.forfun.com/fetch/29/2942cda3da91073bcaf9915bec9195d5.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    private func fetchImage() {
        
        guard let url = URL(string: imageURL2) else { return }
        
        let urlRequest = URLRequest(url: url)
        
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            print(data)
//            print(response)
//            print(error)
//        }.resume()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
//            print(data)
//            print(response)
//            print(error)
            
            /*
             работа с UI всегда идет в главном потоке (main thread)
             */
            
            DispatchQueue.main.async {
                
                self?.activityIndicatorView.stopAnimating()
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let response = response {
                    print(response)
                }
                
                if let data = data,
                let image = UIImage(data: data) {
                    self?.imageView.image = image
                } else {
                    // тут можно пользователю показать ошибку картинки
                }
            }
        }
        task.resume()
    }
}
