//
//  NetworkService.swift
//  RestApp
//
//  Created by Alexandr Filovets on 17.10.23.
//

import Alamofire
import AlamofireImage
import Foundation
import SwiftyJSON
import UIKit

final class NetworkService {
    static func deletePost(postID: Int, callback: @escaping (_ result: JSON?, _ error: Error?) -> ()) {
        let urlPath = "\(ApiConstants.postsPath)/\(postID)"
        
        AF.request(urlPath, method: .delete, encoding: JSONEncoding.default)
            .response { response in

                var jsonValue: JSON?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(jsonValue, err)
                        return
                    }
                    jsonValue = JSON(data)
                case .failure(let error):
                    err = error
                }
                callback(jsonValue, err)
            }
    }
    
    static func fetchComments(postID: Int, callback: @escaping (_ result: [Comment]?, _ error: Error?) -> ()) {
        let urlPath = "\(ApiConstants.commentsPath)?postId=\(postID)"
        
        AF.request(urlPath, method: .get, encoding: JSONEncoding.default)
            .response { response in

                var value: [Comment]?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(value, err)
                        return
                    }
                    print(JSON(data))
                    do {
                        value = try JSONDecoder().decode([Comment].self, from: data)
                    } catch (let decoderError) {
                        callback(value, decoderError)
                    }
                case .failure(let error):
                    err = error
                }
                callback(value, err)
            }
    }
    
    static func fetchAlbums(userID: Int, callback: @escaping (_ result: [Album]?, _ error: Error?) -> ()) {
        let urlPath = "\(ApiConstants.albumsPath)?userId=\(userID)"
        
        AF.request(urlPath, method: .get, encoding: JSONEncoding.default)
            .response { response in

                var value: [Album]?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(value, err)
                        return
                    }
                    do {
                        value = try JSONDecoder().decode([Album].self, from: data)
                    } catch (let decoderError) {
                        callback(value, decoderError)
                    }
                case .failure(let error):
                    err = error
                }
                callback(value, err)
            }
    }
    
    static func fetchPhotos(albumID: Int, callback: @escaping (_ result: [Photo]?, _ error: Error?) -> ()) {
        let urlPath = "\(ApiConstants.photosPath)?albumId=\(albumID)"
        
        AF.request(urlPath, method: .get, encoding: JSONEncoding.default)
            .response { response in

                var value: [Photo]?
                var err: Error?

                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        callback(value, err)
                        return
                    }
                    do {
                        value = try JSONDecoder().decode([Photo].self, from: data)
                    } catch (let decoderError) {
                        callback(value, decoderError)
                    }
                case .failure(let error):
                    err = error
                }
                callback(value, err)
            }
    }
    
    static func getThumbnail(thumbnailURL: String, callback: @escaping (_ result: UIImage?, _ error: AFError?) -> ()) {
        if let image = CacheManager.shared.imageCache.image(withIdentifier: thumbnailURL) {
            callback(image, nil)
        } else {
            AF.request(thumbnailURL).responseImage { response in
                switch response.result {
                case .success(let image):
                    CacheManager.shared.imageCache.add(image, withIdentifier: thumbnailURL)
                    callback(image, nil)
                case .failure(let error):
                    callback(nil, error)
                }
            }
        }
    }
    
    /// напишем универсальные методы для загрузки любых типов данных

    static func getData(from url: URL, complition: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: complition).resume()
    }
    
    static func downloadImage(from url: URL, callback: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        getData(from: url) { data, _, error in
            /// тут можно добавить логику
            ///  - обработки ошибо
            ///  - преобразования картинок
            if let data,
               let image = UIImage(data: data)
            {
                callback(image, nil)
            } else {
                callback(nil, error)
            }
        }
    }
}
