//
//  SearchViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PodcastManagerDelegate, NewstManagerDelegate, SermonManagerDelegate, UISearchBarDelegate{
  

    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var findContentLabel: UILabel!
    @IBOutlet var searchForContentLabel: UILabel!
    
    
    var podcastManager = PodcastManager()
    var sermonManager = SermonManager()
    var newsManager = NewsManager()
    
    var sermons = [Sermon]()
    var podcasts = [Podcast]()
    var news = [NewsData]()
    
    // variables for search algorithm
    var allData = [Any]()
    var secondFilteredData = [Any]()
    var searchBarIsEmpty = true
    var dataFromSearch: Any = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar(frame: CGRect(origin: CGPoint(x: 0, y: 80), size: CGSize(width: view.frame.width, height: 40)))
        
        view.addSubview(searchBar)
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchidentifier")
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        
        searchTableView.isHidden = true
        self.searchTableView.keyboardDismissMode = .onDrag
        self.hideKeyboardWhenTappedAround()
    
        podcastManager.delegate = self
        newsManager.delegate = self
        sermonManager.delegate = self
        
        
        podcastManager.fetchPodcasts()
        newsManager.fetchNews()
        sermonManager.fetchSermons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // This helps to hide show the tableview when the navigationbar is on another screen
        // and the search bar still contains some text that show that the search is still on
        searchTableView.isHidden = true
        if !searchBarIsEmpty{searchTableView.isHidden = false}
        else{searchTableView.isHidden = true}
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchidentifier", for: indexPath) as? SearchTableViewCell {
            cell.configureCell(data: secondFilteredData, index: indexPath.row)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    // be sure to refactor this search algorithm 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        secondFilteredData = []
        if allData.isEmpty{
            for info in self.sermons{allData.append(info)}
            for info in self.podcasts{allData.append(info)}
            for info in self.news{allData.append(info)}
        }
        if searchText == ""{
            searchBarIsEmpty = true
            searchTableView.isHidden = true
            tabBarController?.tabBar.isHidden = false
        }
        else{
            tabBarController?.tabBar.isHidden = true
            searchTableView.isHidden = false
            searchBarIsEmpty = false
            for item in allData{
                if item is Sermon{
                    let gottenItem = item as! Sermon
                    if gottenItem.title.lowercased().contains(searchText.lowercased()) || gottenItem.sermonPastor.first_name.lowercased().contains(searchText.lowercased()) || gottenItem.sermonPastor.last_name.lowercased().contains(searchText.lowercased())  {
                        secondFilteredData.append(gottenItem)
                    }
                        
                }
                else if item is Podcast{
                    let gottenItem = item as! Podcast
                    if gottenItem.title.lowercased().contains(searchText.lowercased()){
                        secondFilteredData.append(gottenItem)
                    }
                                        
                }
                
                else if item is NewsData{
                    let gottenItem = item as! NewsData
                    if gottenItem.title.lowercased().contains(searchText.lowercased()){
                        secondFilteredData.append(gottenItem)
                    }
                    
                }
            }
        }
        self.searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataFromSearch = secondFilteredData[indexPath.row]
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    
    
    func didUpdateSermonData(sermon: [Sermon]?) {
        DispatchQueue.main.async {
            //print(sermon!)
            if let sermon = sermon{
                self.sermons = sermon
                self.searchTableView.reloadData()
            }
        }
    }
    
    func didUpdateNewsData(news: [NewsData]?) {
        DispatchQueue.main.async {
            //print(news!)
            if let news = news{
                self.news = news
                self.searchTableView.reloadData()
            }
        }
    }
    
    func didUpdatePodcastData(podcast: [Podcast]?) {
        DispatchQueue.main.async {
            //print(podcast!)
            if let podcast = podcast{
                self.podcasts = podcast
                self.searchTableView.reloadData()
                
            }
        }
    }
    
    

}
