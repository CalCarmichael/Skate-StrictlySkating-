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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    
    let postId = "-Khh9SOISk_uuOsmV8zM"
    
    var comments = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        empty()
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ notifcation: NSNotification) {
        print(notifcation)
        let keyboardFrame = (notifcation.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        print(keyboardFrame)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notifcation: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        
        }
        
    }

    
    
    func loadComments() {
        
        let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId)
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            print("observe key")
            print(snapshot.key)
            FIRDatabase.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: {
                snapshotComment in
                
                if let dict = snapshot.value as? [String: Any] {
                    
                    //Retrieving from the database - post Model created class
                    
                    let newComment = Comment.transformComment(dict: dict)
                    
                    self.getUser(uid: newComment.uid!, completed: {
                        
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                        
                        
                    })
                    
                }
            })
        })
        
    }
    
    func getUser(uid: String, completed: @escaping () -> Void ) {
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        })
        
        
        
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
            
            
            let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            self.empty()
            self.view.endEditing(true)
            
        })
        
    }
    
    func empty() {
        
        self.commentTextField.text = ""
        self.commentSendButton.isEnabled = false
        self.commentSendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        
    }
    
    
}

extension CommentViewController: UITableViewDataSource {
    
    //Rows in table view - returning posts
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
    }
    
    //Customise rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Reuses the cells shown rather than uploading all of them at once
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        //Posting the user information from Folder Views - FeedTableViewCell
        
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
}

