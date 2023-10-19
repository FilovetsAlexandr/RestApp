//
//  ToDoModel.swift
//  RestApp
//
//  Created by Alexandr Filovets on 17.10.23.
//

import Foundation

struct ToDo: Codable {
    let userId: Int
    let id: Int
    let title: String?
    let body: String?
}

