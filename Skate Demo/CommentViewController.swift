//
//  CommentViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 11/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {

    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var commentSendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        empty()
        handleTextField()
        loadComments
        
        
    }
    
    func loadComments() {
        
    
        
    }
    
    func handleTextField() {
        
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            commentSendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            commentSendButton.isEnabled = true
            return
        }

    
        commentSendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        commentSendButton.isEnabled = false
        
    }


        override func viewWillAppear(_animated: Bool) {
            super.viewWillAppear(animated)
            
            //Get rid of tab bar on this page
            
            self.tabBarController?.tabBar.isHidden = true
            
            
    }
    

    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
    
        let ref = FIRDatabase.database().reference()
        let commentsReference = ref.child("posts")
        let newCommentId = postsReference.childByAutoId().key
        let newCommentReference = CommentsReference.child(newCommentId)
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!], withCompletionBlock: {
            (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let postId = ""
            let postCommentReference = FIRDatabase.database().reference()("post-comment").child(postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            
            })
                
            self.empty()
            
        })
        
    }
    
    func empty() {
        self.commentTextField.text = //Can put in fake data here to test
        self.commentSendButton.isEnabled = false
        self.commentSendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        
    }
    
    
}


