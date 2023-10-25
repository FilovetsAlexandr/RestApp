//
//  AlbumsTVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 17.10.23.
//

import UIKit

final class AlbumsTVC: UITableViewController {
    
    var user: User?
    var albums: [Album]?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAlboms()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { albums?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let album = albums?[indexPath.row]
        cell.textLabel?.text = album?.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums?[indexPath.row]
        performSegue(withIdentifier: "showPhotos", sender: album)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
           let vc = segue.destination as? PhotosCVC,
           let album = sender as? Album {
            vc.album = album
        }
    }
    
    private func fetchAlboms() {
        guard let user = user else { return  }
        NetworkService.fetchAlbums(userID: user.id) { [weak self] albums, error in
            if let error = error {
                print(error)
            } else if let albums = albums {
                self?.albums = albums
                self?.tableView.reloadData()
            }
        }
    }
}
