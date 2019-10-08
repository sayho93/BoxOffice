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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setupTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setupTextView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            comment.resignFirstResponder()
        }
        return true
    }
    
    func setupTextView(){
        if comment.textColor == .placeholderText {
            print("textView textColor is placeholderText")
            comment.text = nil
            if traitCollection.userInterfaceStyle == .light{
                comment.textColor = .darkText
            }else if traitCollection.userInterfaceStyle == .dark{
                comment.textColor = .lightText
            }
        }else if comment.text.isEmpty {
            print("textView is empty")
            comment.text = "한줄평을 작성해주세요"
            comment.textColor = UIColor.placeholderText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieID = SingletonInstance.instance.getInfo("movieID") as? String
        initNavigation()
        let title = SingletonInstance.instance.getInfo("movieTitle")
        let grade = SingletonInstance.instance.getInfo("grade")
        self.movieTitle.attributedText = self.makeAttributedString(title: title as! String, grade: grade as! Int, target: self.movieTitle)
        comment.delegate = self
        setupTextView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == .dark{
            comment.textColor = .darkText
        }else{
            comment.textColor = .lightText
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
        SingletonInstance.instance.reInit()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addComment(){
        
    }

}
