//
//  RealmStorage.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Foundation


class FindPhotoModel : Codable {
    
    let pictureModelArray: [PhotoModel]
    
    enum CodingKeys: String, CodingKey {
        case pictureModelArray = "results"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pictureModelArray = try values.decode([PhotoModel].self, forKey: .pictureModelArray)
    }
}
    
class PhotoModel : Codable {
    let id : String?
    let created_at : String?
    let updated_at : String?
    let promoted_at : String?
    let width : Int?
    let height : Int?
    let color : String?
    let description : String?
    let alt_description : String?
    let urls : Urls?
    let links : Links?
    let categories : [String]?
    let likes : Int?
    let liked_by_user : Bool?
    let current_user_collections : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case promoted_at = "promoted_at"
        case width = "width"
        case height = "height"
        case color = "color"
        case description = "description"
        case alt_description = "alt_description"
        case urls = "urls"
        case links = "links"
        case categories = "categories"
        case likes = "likes"
        case liked_by_user = "liked_by_user"
        case current_user_collections = "current_user_collections"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        promoted_at = try values.decodeIfPresent(String.self, forKey: .promoted_at)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        alt_description = try values.decodeIfPresent(String.self, forKey: .alt_description)
        urls = try values.decodeIfPresent(Urls.self, forKey: .urls)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes)
        liked_by_user = try values.decodeIfPresent(Bool.self, forKey: .liked_by_user)
        current_user_collections = try values.decodeIfPresent([String].self, forKey: .current_user_collections)
    }

}


class Links : Codable {

    let html : String?
    let photos : String?
    let likes : String?
    let portfolio : String?
    let following : String?
    let followers : String?

    enum CodingKeys: String, CodingKey {

        case html = "html"
        case photos = "photos"
        case likes = "likes"
        case portfolio = "portfolio"
        case following = "following"
        case followers = "followers"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
    
        html = try values.decodeIfPresent(String.self, forKey: .html)
        photos = try values.decodeIfPresent(String.self, forKey: .photos)
        likes = try values.decodeIfPresent(String.self, forKey: .likes)
        portfolio = try values.decodeIfPresent(String.self, forKey: .portfolio)
        following = try values.decodeIfPresent(String.self, forKey: .following)
        followers = try values.decodeIfPresent(String.self, forKey: .followers)
    }
    
}




class Urls : Codable {
    let raw : String?
    let full : String?
    let regular : String?
    let small : String?
    let thumb : String?

    enum CodingKeys: String, CodingKey {

        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
        case thumb = "thumb"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        raw = try values.decodeIfPresent(String.self, forKey: .raw)
        full = try values.decodeIfPresent(String.self, forKey: .full)
        regular = try values.decodeIfPresent(String.self, forKey: .regular)
        small = try values.decodeIfPresent(String.self, forKey: .small)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
    }
}
