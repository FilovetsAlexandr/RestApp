//
//  PhotoVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 20.10.23.
//

import UIKit

final class PhotoVC: UIViewController {
    
    var photo: Photo?
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "defaultImage.png")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getPhoto()
    }
    
    private func getPhoto() {
        guard let photo,
              let imagePath = photo.url,
              let url = URL(string: imagePath) else { return  }
        NetworkService.downloadImage(from: url) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        view.addSubview(imageView)
        imageView.addSubview(activityIndicatorView)
        
//        setupLayoutAnhors()
        setupNSLayoutConstraints()
    }
    
    private func setupLayoutAnhors() {
        // Get the superview's layout
        let margins = view.layoutMarginsGuide
        // Pin the leading edge of myView to the margin's leading edge
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }
    
    private func setupNSLayoutConstraints() {
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: activityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: activityIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0).isActive = true
    }
}
