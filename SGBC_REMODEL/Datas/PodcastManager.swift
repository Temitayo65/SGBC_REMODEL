//
//  PodcastManager.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 27/09/2022.
//

import Foundation

protocol PodcastManagerDelegate{
    func didUpdatePodcastData(podcast: [Podcast]?)
}

struct PodcastManager{
    let baseURL = "https://still-savannah-43128.herokuapp.com/podcasts"
    var delegate: PodcastManagerDelegate?
   
    
    func fetchPodcasts(){
        performRequest(urlString: baseURL)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let podcast = parseJSON(data: safeData){
                        self.delegate?.didUpdatePodcastData(podcast: podcast)
                    }
                }
            }
            task.resume()
        }
                
    }
    
    func parseJSON(data: Data)-> [Podcast]?{
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(Podcasts.self, from: data){
            let podcasts = data.data
            return podcasts
        }
        return nil
    }
    
}
