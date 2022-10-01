//
//  NewsManager.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import Foundation

protocol NewstManagerDelegate{
    func didUpdateNewsData(news: [NewsData]?)
}

struct NewsManager{
    let baseURL = "https://still-savannah-43128.herokuapp.com/news"
    var delegate: NewstManagerDelegate?
   
    
    func fetchNews(){
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
                    if let news = parseJSON(data: safeData){
                        self.delegate?.didUpdateNewsData(news: news)
                    }
                }
            }
            task.resume()
        }
                
    }
    
    func parseJSON(data: Data)-> [NewsData]?{
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(News.self, from: data){
            let news = data.data
            return news
        }
        return nil
    }
    
}
