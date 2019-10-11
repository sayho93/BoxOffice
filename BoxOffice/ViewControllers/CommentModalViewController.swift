//
//  CommentModalViewController.swift
//  BoxOffice
//
//  Created by 전세호 on 02/10/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class CommentModalViewController: UIViewController, UITextViewDelegate {
    var movieID: String!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if comment.textColor == .placeholderText {
            comment.text = nil
            if traitCollection.userInterfaceStyle == .light{
                comment.textColor = .darkText
            }else if traitCollection.userInterfaceStyle == .dark{
                comment.textColor = .lightText
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if comment.text.isEmpty {
            comment.text = "한줄평을 작성해주세요"
            comment.textColor = UIColor.placeholderText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"{
//            comment.resignFirstResponder()
//        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieID = SingletonInstance.instance.getInfo("movieID") as? String
        initNavigation()
        self.comment.layer.borderColor = UIColor.red.cgColor
        self.comment.layer.borderWidth = 0.3
        self.comment.layer.cornerRadius = 10
        let title = SingletonInstance.instance.getInfo("movieTitle")
        let grade = SingletonInstance.instance.getInfo("grade")
        self.movieTitle.attributedText = self.makeAttributedString(title: title as! String, grade: grade as! Int, target: self.movieTitle)
        if let tmpUserName = SingletonInstance.instance.getInfo("tmpUserName") as? String{
            self.userName.text = tmpUserName
        }
        comment.delegate = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if comment.textColor != UIColor.placeholderText{
            if previousTraitCollection?.userInterfaceStyle == .dark{
                    comment.textColor = .darkText
            }else{
                comment.textColor = .lightText
            }
        }
    }
    
    private func initNavigation(){
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = Config.colors.themeColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "한줄평 작성"
        
        let leftBarBtn = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.dismissModal))
        let rightBarBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.addComment))
        self.navigationItem.leftBarButtonItem  = leftBarBtn
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    func makeAttributedString(title: String, grade: Int, target: UILabel) -> NSMutableAttributedString{
        let mutableString = NSMutableAttributedString(string: title + " ")
        let attachment = NSTextAttachment()
        switch grade {
        case 0:
            attachment.image = UIImage(named: "ic_allages")
        case 12:
            attachment.image = UIImage(named: "ic_12")
        case 15:
            attachment.image = UIImage(named: "ic_15")
        case 19:
            attachment.image = UIImage(named: "ic_19")
        default:
            attachment.image = UIImage()
        }
        
        attachment.bounds = CGRect(x: 0, y: (target.font.capHeight - (attachment.image?.size.height)!).rounded() / 2, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
        
        let imageAttribute = NSAttributedString(attachment: attachment)
        mutableString.append(imageAttribute)
        
        return mutableString
    }
    
    @objc func dismissModal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addComment(){
        let rating = self.ratingControl.rating
        RequestHandler.saveComment(movieID: self.movieID,userName: self.userName.text!, comment: self.comment.text, rating: rating * 2) { returnCode in
            if returnCode == 1{
                DispatchQueue.main.async {
                    SingletonInstance.instance.setInfo("tmpUserName", self.userName.text!)
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: Notification.DidReceiveCommentRefresh, object: nil)
                    }
                }
            }else{
                print("err")
            }
        }
    }
}
