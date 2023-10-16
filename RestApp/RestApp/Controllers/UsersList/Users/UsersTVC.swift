//
//  UsersTVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 11.10.23.
//
import Alamofire
import UIKit

final class UsersTVC: UITableViewController {
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @IBAction func pushAddAction(_ sender: Any) {
        TextPickerCreateUser().showPicker(in: self) { [weak self] user in
            guard let self = self, let newUser = user else { return }
            self.users.append(newUser)
            self.tableView.reloadData()
            addUser(user: newUser) { [weak self] in guard self != nil else { return }
            }
        }
    }

    // MARK: - Table view data source

    // Удаление свайпом
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < users.count else { return }
            
            let user = users[indexPath.row]
            
            // Удаляем пользователя из бд
            deleteUser(userId: user.id) { [weak self] in
                guard let self = self else { return }
                
                // Удаляем пользователя из источника данных
                if indexPath.row < self.users.count {
                    self.users.remove(at: indexPath.row)
                    // Обновляем таблицу
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    // Редактиорование свайпом
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            guard let user = self?.users[indexPath.row] else {
                completion(false)
                return
            }
            
            let textPicker = TextPickerEditUser()
            if let selfStrong = self {
                textPicker.showPicker(for: user, in: selfStrong) { updatedUser in
                    if let updatedUser = updatedUser {
                        self?.users[indexPath.row] = updatedUser
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        self?.uploadUser(user: updatedUser) { [weak self] in guard self != nil else { return } }
                    }
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [editAction])
    }

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
                detailsVC.navigationItem.title = users[indexPath.row].name
            }
        }
    }
    // Получение пользователей
    private func fetchUsers() {
        guard let usersURL = ApiConstants.usersURL else { return }
        
        AF.request(usersURL).responseDecodable(of: [User].self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            self.refreshControl?.endRefreshing()
        }
    }

    // Добавление пользователя
    private func addUser(user: User, callback: @escaping () -> ()) {
        guard let addUserURL = ApiConstants.usersURL else { return }
        AF.request(addUserURL, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .response { _ in callback() }
    }

    // Удаление пользователя
    private func deleteUser(userId: Int, callback: @escaping () -> ()) {
        let urlUser = "\(ApiConstants.usersPath)/\(userId)"
        AF.request(urlUser, method: .delete, encoding: JSONEncoding.default)
            .response { _ in callback() }
    }

    // Редактирование пользователя
    private func uploadUser(user: User, callback: @escaping () -> ()) {
        guard let uploadURL = ApiConstants.usersURL else { return }
        
        let userURL = "\(ApiConstants.usersPath)/\(user.id)"
        
        AF.request(userURL, method: .put, parameters: user, encoder: JSONParameterEncoder.default)
            .response { _ in callback() }
    }
    
    @objc private func refreshUsers() { fetchUsers() }
}
