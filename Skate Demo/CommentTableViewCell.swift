//
//  CommentTableViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 11/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var comment: Comment? {
        didSet {
            
            updateView()
            
            
        }
    }
    
    var user: User? {
        didSet {
            
            setUserInfo()
            
        }
    }
    
    
    func updateView() {
        
        commentLabel.text = comment?.commentText
        
    }
    
    func setUserInfo() {
        
        usernameLabel.text = user?.username
        
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImage"))
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        usernameLabel.text = ""
        commentLabel.text = ""
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImage")
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
