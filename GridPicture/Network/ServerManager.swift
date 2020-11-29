//
//  ServerManager.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Alamofire
import Foundation

class ServerManager {
    
    static let shared = ServerManager()
    let photos = "https://api.unsplash.com/photos/?client_id=4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
    let searchPhotos = "https://api.unsplash.com/search/photos/?client_id=4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
    
    func listPhotos(pageNumber: Int, completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(photos, method: .get, parameters: ["per_page": 30, "page": pageNumber], headers: nil).responseJSON(completionHandler: completion)
    }
    
    func findPhotos(searchText: String, pageNumber: Int, completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(searchPhotos, method: .get, parameters: ["query": searchText, "page": pageNumber, "per_page": 30], headers: nil).responseJSON(completionHandler: completion)
     }
    
    
}
