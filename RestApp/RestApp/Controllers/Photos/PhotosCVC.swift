//
//  PhotoCVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 20.10.23.
//

import UIKit

class PhotosCVC: UICollectionViewController {
    
    var album: Album?
    var photos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoCVCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let layout = UICollectionViewFlowLayout()
        let sizeWH = UIScreen.main.bounds.width / 2 - 5
        layout.itemSize = CGSize(width: sizeWH, height: sizeWH)
        collectionView.collectionViewLayout = layout
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCVCell
        cell.thumbnailUrl = photo?.thumbnailUrl
        return cell
    }
    
    private func fetchPhotos() {
        guard let album = album else { return  }
        NetworkService.fetchPhotos(albumID: album.id) { [weak self] photos, error in
            if let error = error {
                print(error)
            } else if let photos = photos {
                self?.photos = photos
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos?[indexPath.row]
        let vc = PhotoVC()
        vc.photo = photo
        self.present(vc, animated: true)
    }
}
