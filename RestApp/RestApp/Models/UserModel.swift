//
//  Models.swift
//  RestApp
//
//  Created by Alexandr Filovets on 11.10.23.
//

import Foundation

/// 1) подписываемся под Codable
/// 2) если вы предпологаете что данные могут не прийти делаем опцтонал "?"
/// 3) имена свойств точно совпадают с именами параметров

struct User: Codable {
    let id: Int
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
}

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

struct Geo: Codable {
    let lat: String?
    let lng: String?
}

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}
