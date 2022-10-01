//
//  NewsViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 01/10/2022.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewstManagerDelegate{
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    @IBOutlet var newsTableView: UITableView!
    var newsManager = NewsManager()
    var news = [NewsData]()
    let refreshControl = UIRefreshControl()
    var currentIndexPath: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hiding the navigation bar
        navigationController?.navigationBar.isHidden = true
        
        newsTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newscellidentifier")
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsManager.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
        
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        newsManager.fetchNews()
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        newsManager.fetchNews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newscellidentifier", for: indexPath) as? NewsTableViewCell{
            cell.configureCell(news: news, indexPath: indexPath)
            cell.newsTimeLabel.text = slice(news[indexPath.row].updated_at, from: 0, to: "T") // ask Dara for how to get the time here from the API
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndexPath = indexPath.row
        performSegue(withIdentifier: "newsdetailssegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsdetailssegue"{
            let vc = segue.destination as! NewsDetailsViewController
            vc.newsBody = news[currentIndexPath].body
            vc.newsTitle = news[currentIndexPath].title
            vc.newsImageURL = news[currentIndexPath].newsImage.image_url
        }
    }
    

    func didUpdateNewsData(news: [NewsData]?) {
        DispatchQueue.main.async {
            if let news = news{
                self.news = news
                self.news.sort(){$0.updated_at > $1.updated_at}
                self.newsTableView.reloadData()
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.refreshControl.endRefreshing()
            }
        }
        
    }

}
