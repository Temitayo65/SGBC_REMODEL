//
//  Podcast.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 27/09/2022.
//

import Foundation

struct Podcasts: Codable{
    let status: String
    let message: String
    let data: [Podcast]
}

struct Podcast: Codable{
    let id: String
    let title: String
    let episode_number: Int
    let date_recorded: String
    let podcast_image_id: String
    let podcast_audio_id: String
    let created_at: String
    let updated_at: String
    let podcastImage: PodcastImage
    let podcastAudio: PodcastAudio
}

struct PodcastImage: Codable{
    let id: String
    let image_url: String
    let file_name: String
    let last_updated: String
    let is_deleted: Bool
    let created_at: String
    let updated_at: String
}

struct PodcastAudio: Codable{
    let id: String
    let audio_url: String
    let file_name: String
    let last_updated: String
    let is_deleted: Bool
    let created_at: String
    let updated_at: String
}
