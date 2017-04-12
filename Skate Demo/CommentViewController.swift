//
//  CommentViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 11/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class CommentViewController: UIViewController {

    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var commentSendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        empty()
        handleTextField()
       
        
        
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


        override func viewWillAppear(_ _animated: Bool) {
            super.viewWillAppear(_animated)
            
            //Get rid of tab bar on this page
            
            self.tabBarController?.tabBar.isHidden = true
            
            
    }
    

    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
    
        let ref = FIRDatabase.database().reference()
        let commentsReference = ref.child("comments")
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
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

                
            self.empty()
            
        })
        
    }
    
    func empty() {
        
        self.commentTextField.text = ""
        self.commentSendButton.isEnabled = false
        self.commentSendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        
    }
    
    
}


