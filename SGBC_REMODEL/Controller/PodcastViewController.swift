//
//  PodcastViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 27/09/2022.
//

import UIKit

class PodcastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PodcastManagerDelegate{
    

    @IBOutlet var podcastHeaderImageView: UIImageView!
    @IBOutlet var podcastTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var podcastManager = PodcastManager()
    var podcasts = [Podcast]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
       
        podcastManager.delegate = self
        podcastTableView.register(UINib(nibName: "PodcastTableViewCell", bundle: nil), forCellReuseIdentifier: "podcastcellidentifier")
        podcastTableView.delegate = self
        podcastTableView.dataSource = self
        podcastHeaderImageView.image = UIImage(named: "podcastheader")
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        podcastTableView.addSubview(refreshControl)
       
        
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        podcastManager.fetchPodcasts()        
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        podcastManager.fetchPodcasts()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{return 1}
        else{return podcasts.count}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "podcastcellidentifier", for: indexPath) as? PodcastTableViewCell{
            if indexPath.section == 0{
                cell.podcastImageView.image = UIImage(named: "placeholder")
                cell.podcastTitleLabel.text = "A daily podcast from the elders of Sovereign Grace Bible Church."
                cell.podcastTitleLabel.textColor = .black
                cell.podcastDateLabel.isHidden = true
                cell.podcastEpisodeLabel.isHidden = true
            }
            else if indexPath.section == 1{
                // loading image from the endpoint
                let url = URL(string: podcasts[indexPath.row].podcastImage.image_url)!
                cell.podcastImageView.load(url: url)
                //cell.podcastImageView.image = UIImage(named: "placeholder")
                cell.podcastDateLabel.text = slice(podcasts[indexPath.row].date_recorded, from: 0, to: "T")!
                cell.podcastTitleLabel.text = podcasts[indexPath.row].title
                cell.podcastEpisodeLabel.text = "Episode " + String(podcasts[indexPath.row].episode_number)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func didUpdatePodcastData(podcast: [Podcast]?) {
        DispatchQueue.main.async {
            if let podcast = podcast {
                self.podcasts = podcast
                self.podcasts.sort{$0.date_recorded > $1.date_recorded}
                self.podcastTableView.reloadData()
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.refreshControl.endRefreshing()
            }
        }
    }

}
