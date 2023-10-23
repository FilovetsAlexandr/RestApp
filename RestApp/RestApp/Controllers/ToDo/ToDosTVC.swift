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
        ToDosTextPicker().showPicker(in: self) { [weak self] text in
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
                }
            }
        }
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
