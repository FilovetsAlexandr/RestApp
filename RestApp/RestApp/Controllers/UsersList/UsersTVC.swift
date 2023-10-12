//
//  UsersTVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 11.10.23.
//

import UIKit

final class UsersTVC: UITableViewController {
    
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell
        
        let user = users[indexPath.row]
        
        cell.nameLbl.text = user.name
        cell.emailLbl.text = user.email 
        
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailUsersVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailsVC = segue.destination as! DetailUsersVC
                detailsVC.detailUser = users[indexPath.row]
                // изменяем имя навигейшн бара
                detailsVC.navigationItem.title = users[indexPath.row].name
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func fetchUsers() {
        
        guard let usersURL = ApiConstants.usersURL else { return }
        
        URLSession.shared.dataTask(with: usersURL) { [weak self] data, response, error in
            
            guard let self else { return }
            
            print(response)
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    self.users = try JSONDecoder().decode([User].self, from: data)
                    print(users)
                } catch {
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }.resume()
    }
}
