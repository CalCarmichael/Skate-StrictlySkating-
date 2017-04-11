//
//  FeedTableViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 06/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var dislikeImageView: UIImageView!
    @IBOutlet weak var commentView: UIImageView!
    @IBOutlet weak var shareView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    //Created an instance variable 
    
    var post: Post? {
        didSet {
            
        updateViewPost()
            
            
        }
    }
    
    func updateViewPost() {
        
        captionLabel.text = post?.caption
        
        //Getting photo url from database
        
        if let photoUrlString = post?.photoUrl {
            
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
            
        }

        setUserInfo()
            
        }
    
        //Grabbing all user information its observing and retrieving from specific user uid
        
        func setUserInfo() {
            
          if let uid = post?.uid {
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: {
                snapshot in 
                if let dict = snapshot.value as? [String: Any] {
                    
                    //Retrieving from the database - Model User created class
                    
                    let user = User.transformUser(dict: dict)
                    self.usernameLabel.text = user.username
                    if let photoUrlString = user.profileImageUrl {
                        let photoUrl = URL(string: photoUrlString)
                        self.profileImageView.sd_setImage(with: photoUrl)
                        
                    }
                    
                }

            })
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
