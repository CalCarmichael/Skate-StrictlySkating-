//
//  FeedViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 06/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
        
        
    }
    
    //Retrieving the posts from the database with child added - updates only what we want not everything
    
    func loadPosts() {
        
        FIRDatabase.database().reference().child("posts").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                //Retrieving from the database - post Model created class
                
                let newPost = Post.transformPostPhoto(dict: dict)
                
                self.posts.append(newPost)
                print(self.posts)
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
}

extension FeedViewController: UITableViewDataSource {
    
    //Rows in table view - returning posts
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // return posts.count
        
        return 10
    }
    
    //Customise rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Reuses the cells shown rather than uploading all of them at once
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedTableViewCell
        
        //Inputting user post information 
        
        cell.profileImageView.image = UIImage(named: "Man")
        cell.usernameLabel.text = "Callum"
        cell.postImageView.image = UIImage(named: "Man")
        cell.captionLabel.text = "Some text"
        
       // cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
}
