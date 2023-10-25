//
//  CommentsTVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 20.10.23.
//

import UIKit

final class CommentsTVC: UITableViewController {
    var postID: Int?
    var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { comments.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.name
        cell.detailTextLabel?.text = comment.body
        return cell
    }

    private func fetchComments() {
        guard let postID = postID else { return }
        NetworkService.fetchComments(postID: postID) { [weak self] comments, error in
            if let error = error {
                print(error)
            } else if let comments = comments {
                self?.comments = comments
                self?.tableView.reloadData()
            }
        }
    }
}
