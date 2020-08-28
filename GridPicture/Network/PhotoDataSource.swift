//
//  PictureDataSource.swift
//  GridPicture
//
//  Created by Роман Чугай on 27.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Alamofire


protocol PictureDataSourceType {
    func fetchPhotos(pageNumber: Int, completion: @escaping (_ result: [PhotoModel]) -> Void)
    func findPhotos(searchText: String, pageNumber: Int, completion: @escaping ([PhotoModel]) -> Void)
}

final class PhotoDataSource: PictureDataSourceType {
    
    func fetchPhotos(pageNumber: Int, completion: @escaping ([PhotoModel]) -> Void) {
        ServerManager.shared.listPhotos(pageNumber: pageNumber) { (response) in
            switch response.response?.statusCode {
            case 200?:
                if let data = response.data, let result = try? JSONDecoder().decode([PhotoModel].self, from: data) {
                    completion(result)
                }
            default:
                completion([])
            }
        }
    }
    
    func findPhotos(searchText: String, pageNumber: Int, completion: @escaping ([PhotoModel]) -> Void) {
        ServerManager.shared.findPhotos(searchText: searchText, pageNumber: pageNumber) { (response) in
            switch response.response?.statusCode {
            case 200?:
                if let data = response.data, let result = try? JSONDecoder().decode(FindPhotoModel.self, from: data) {
                    completion(result.pictureModelArray)
                }
            default:
                completion([])
            }
        }
    }

}
