//
//  ToDosTVC.swift
//  RestApp
//
//  Created by Alexandr Filovets on 17.10.23.
//
import Alamofire
import UIKit

final class ToDosTVC: UITableViewController {
    var user: User?
    var toDos: [ToDo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchToDo()
    }
    
    // Добавление новой todo
    @IBAction func pushAddAction(_ sender: Any) {
        ToDosTextPicker().showPicker(in: self, text: "") { [weak self] text in
            let newId = (self?.toDos?.last?.id ?? 0) + 1
            let newToDo = ToDo(userId: self?.user?.id ?? 0, id: newId, title: text, completed: false)
            self?.toDos?.append(newToDo)
            self?.tableView.reloadData()
            
            // Отправить новую задачу на сервер с помощью Alamofire
            let parameters: [String: Any] = [
                "userId": newToDo.userId,
                "title": newToDo.title as Any,
                "completed": newToDo.completed
            ]
            
            guard let url = URL(string: "http://localhost:3000/todos/") else { return }
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                // Обработка ответа от сервера
                if let error = response.error {
                    print("Ошибка при отправке данных на сервер: \(error)")
                } else {
                    print("Данные успешно обновлены на сервере")
                    self?.fetchToDo()
                }
            }
        }
    }
        
    // Удаление todo
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < toDos?.count ?? 0 else { return }
            
            // Отправляем запрос на сервер для удаления задачи
            guard let toDo = toDos?[indexPath.row] else { return }
            let url = URL(string: "http://localhost:3000/todos/\(toDo.id)")!
            
            AF.request(url, method: .delete).response { response in
                if let error = response.error {
                    print("Ошибка при удалении задачи: \(error)")
                } else {
                    print("Задача успешно удалена")
                    
                    // Обновляем данные в таблице
                    self.toDos?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    // Редактирование
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            guard let toDo = self?.toDos?[indexPath.row] else {
                completionHandler(false)
                return
            }
            
            let picker = ToDosTextPicker()
            picker.showPicker(in: self!, text: toDo.title ?? "") { [weak self] text in
                let updatedToDo = ToDo(userId: toDo.userId, id: toDo.id, title: text, completed: toDo.completed)
                self?.toDos?[indexPath.row] = updatedToDo
                tableView.reloadRows(at: [indexPath], with: .none)
                
                // Отправляем обновленные данные на сервер с помощью Alamofire
                let parameters: [String: Any] = [
                    "title": updatedToDo.title as Any
                ]
                
                guard let url = URL(string: "http://localhost:3000/todos/\(updatedToDo.id)") else {
                    completionHandler(false)
                    return
                }
                
                AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default).response { response in
                    // Обработка ответа от сервера
                    if let error = response.error {
                        print("Ошибка при отправке данных на сервер: \(error)")
                    } else {
                        print("Данные успешно обновлены на сервере")
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                
                completionHandler(true)
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { toDos?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let toDo = toDos?[indexPath.row] else { return }
        
        let updatedToDo = ToDo(userId: toDo.userId, id: toDo.id, title: toDo.title, completed: !toDo.completed)
        toDos?[indexPath.row] = updatedToDo
        tableView.reloadRows(at: [indexPath], with: .none)
        
        // Отправляем обновленные данные на сервер с помощью Alamofire
        let parameters: [String: Any] = [
            "completed": updatedToDo.completed
        ]
        
        guard let url = URL(string: "http://localhost:3000/todos/\(updatedToDo.id)") else { return }
        
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default).response { response in
            // Обработать ответ от сервера
            if let error = response.error {
                print("Ошибка при отправке данных на сервер: \(error)")
            } else {
                print("Данные успешно обновлены на сервере")
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let toDo = toDos?[indexPath.row]
        cell.textLabel?.text = toDo?.title
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = toDo?.completed ?? false ? UIImage(named: "check.png") : UIImage(named: "uncheck.png")
               
        cell.accessoryView = imageView
        
        return cell
    }

       
   private func fetchToDo() {
           let userId = user?.id.description ?? ""
           let urlPath = "\(ApiConstants.todosPath)?userId=\(userId)"
           guard let url = URL(string: urlPath) else { return }
           
           let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
               guard let self, let data = data else { return }
               do {
                   self.toDos = try JSONDecoder().decode([ToDo].self, from: data)
               } catch {
                   print(error)
               }
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
           task.resume()
       }
   }
