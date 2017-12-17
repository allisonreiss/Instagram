//
//  HomeFeedViewController.swift
//  Instagram
//
//  Created by Allison Reiss on 12/8/17.
//  Copyright © 2017 Allison Reiss. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var feed: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 650
        
        // Initialize UI refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // Add refresh contorl to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        loadPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPosts()
    }
    
    func loadPosts() {
        // Query
        let query = PFQuery(className: "Post")
        query.order(byDescending: "_created_at")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.feed = posts
                self.tableView.reloadData()
            }
            else {
                print(error?.localizedDescription ?? "")
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let post = feed[indexPath.row]
        cell.captionLabel.text = post["caption"] as! String?
        
        let photo = post["media"] as! PFFile
        photo.getDataInBackground { (data: Data?, error: Error?) in
            if let data = data {
                cell.photoImageView.image = UIImage(data: data)
            }
            else {
                print(error?.localizedDescription ?? "")
            }
        }
        
        var date: String = ""
        let secondsBetween = Int(Date().timeIntervalSince(post.createdAt!))
        if secondsBetween < 60 {
            date = "\(secondsBetween) SECONDS AGO"
        }
        if secondsBetween < 120 {
            date = "1 MINUTE AGO"
        }
        else if secondsBetween < 3600 {
            date = "\(secondsBetween / 60) MINUTES AGO"
        } else if secondsBetween < 7201 {
            date = "1 HOUR AGO"
        } else if secondsBetween < 86400 {
            date = "\(secondsBetween / 3600) HOURS AGO"
        } else if secondsBetween < 86401 {
            date = "1 DAY AGO"
        } else {
            date = "\(secondsBetween / 86400) DAYS AGO"
        }
        
        cell.timeLabel.text = date
        
        return cell
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadPosts()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
