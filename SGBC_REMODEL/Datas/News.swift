//
//  News.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import Foundation

struct News: Codable{
    let status: String
    let message: String
    let data: [NewsData]
    
}

struct NewsData: Codable{
    let id: String
    let title: String
    let body: String
    let news_image_id: String
    let created_at: String
    let updated_at: String
    let newsImage: NewsImage
}

struct NewsImage: Codable{
    let id: String
    let image_url: String
    let file_name: String
    let last_updated: String
    let is_deleted: Bool
    let created_at: String
    let updated_at: String
}
