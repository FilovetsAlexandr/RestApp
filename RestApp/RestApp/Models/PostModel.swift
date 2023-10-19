//
//  PostModel.swift
//  RestApp
//
//  Created by Alexandr Filovets on 17.10.23.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String?
    let body: String?
}
