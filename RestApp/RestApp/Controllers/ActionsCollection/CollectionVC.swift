//
//  CollectionVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 11.10.23.
//

import UIKit

/// CaseIterable - создать массив из enum
enum UserActions: String, CaseIterable {
    case downloadImage = "Download image"
    case users = "Open users list"
}

class CollectionVC: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    private let userActions = UserActions.allCases

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActionCVCell
        let userAction = userActions[indexPath.row].rawValue
        cell.infiLbl.text = userAction
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.row]
        switch userAction {
            case .downloadImage: performSegue(withIdentifier: "goToImageVC", sender: nil)
            case .users: performSegue(withIdentifier: "openUsersList", sender: nil)
        }
    }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 50, height: 80)
    }
}
