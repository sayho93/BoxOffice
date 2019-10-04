//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by 전세호 on 10/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var id: String!
    private var movie: MovieDetail!
    var navigationTitle: String!
    private var comments: [Comment] = []
    let cellIdentifier: String = "commentTableCell"
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
        
    @IBOutlet weak var reservationRate: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var rateStar: UILabel!
    @IBOutlet weak var accumulate: UILabel!
    
    @IBOutlet weak var synopsis: UITextView!
    
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var actor: UILabel!
    
    @IBOutlet weak var writeComment: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CommentTableViewCell else{
            return UITableViewCell()
        }
        
        let comment: Comment = self.comments[indexPath.row]
        cell.userID.text = comment.writer
        cell.content.text = comment.contents
        let date = Date(timeIntervalSince1970: comment.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.string(from: date)
        cell.timestamp.text = String(strDate)
        cell.rating.attributedText = self.drawStar(rate: comment.rating, label: cell.rating)
        
        
        if indexPath.row == comments.count - 1{
            DispatchQueue.main.async {
                self.tableViewHeight.constant = self.commentTableView.contentSize.height
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        self.view.bringSubviewToFront(spinner)
        self.navigationItem.title = navigationTitle
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetail(_:)), name: Notification.DidReceiveMovieDetail, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCommentList(_:)), name: Notification.DidReceiveCommentList, object: nil)
        
        RequestHandler.getMovieDetail(id: self.id) {
            self.setData()
        }
        
        RequestHandler.getCommentList(id: self.id) {
            
        }
        
        self.tableViewHeight.constant = CGFloat(2000)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setData(){
        DispatchQueue.global().async {
            guard let thumbURL: URL = URL(string: self.movie.image) else{return}
            guard let thumbData: Data = try? Data(contentsOf: thumbURL) else{return}
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: thumbData)
                self.movieTitle.attributedText = self.makeAttributedString(movie: self.movie, label: self.movieTitle)
                self.date.text = self.movie.date + "개봉"
                self.movieInfo.text = "\(self.movie.genre)/\(self.movie.duration)분"
                self.reservationRate.text = String(self.movie.reservationRate)
                self.rate.text = String(self.movie.userRating)
                self.accumulate.text = String(self.movie.audience)
                self.rateStar.attributedText = self.drawStar(rate: self.movie.userRating, label: self.rateStar)
                
                self.synopsis.text = self.movie.synopsis
                
                self.director.text = self.movie.director
                self.actor.text = self.movie.actor
                
                self.spinner.stopAnimating()
            }
        }
    }
    
    func drawStar(rate: Double, label: UILabel) -> NSMutableAttributedString{
        let mutableString = NSMutableAttributedString()
        
        let fullStar: UIImage = UIImage(named: "ic_star_large_full")!
        let halfStar: UIImage = UIImage(named: "ic_star_large_half")!
        let emptyStar: UIImage = UIImage(named: "ic_star_large")!
        
        let fsAttachment = NSTextAttachment()
        fsAttachment.image = fullStar
        let hsAttachment = NSTextAttachment()
        hsAttachment.image = halfStar
        let esAttachment = NSTextAttachment()
        esAttachment.image = emptyStar
        
        let bounds = CGRect(x: 0, y: (label.font.capHeight - (fsAttachment.image?.size.height)!).rounded() / 2, width: ((fsAttachment.image?.size.width)! / 3), height: ((fsAttachment.image?.size.height)! / 3))
        fsAttachment.bounds = bounds
        hsAttachment.bounds = bounds
        esAttachment.bounds = bounds
        
        for i in 1..<6{
            if Double(i) * 2 <= rate + 0.2{
                mutableString.append(NSAttributedString(attachment: fsAttachment))
            }else{
                let diff = Double(i) * 2 - rate
                if diff <= 1.4 && diff >= 0.6{
                    mutableString.append(NSAttributedString(attachment: hsAttachment))
                }else{
                    mutableString.append(NSAttributedString(attachment: esAttachment))
                }
            }
        }
        return mutableString
    }
    
    func makeAttributedString(movie: MovieDetail, label: UILabel) -> NSMutableAttributedString{
        let mutableString = NSMutableAttributedString(string: movie.title + " ")
        let attachment = NSTextAttachment()
        switch movie.grade {
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
        
        attachment.bounds = CGRect(x: 0, y: (label.font.capHeight - (attachment.image?.size.height)!).rounded() / 2, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
        
        let imageAttribute = NSAttributedString(attachment: attachment)
        mutableString.append(imageAttribute)
        
        return mutableString
    }
    
    @objc func didReceiveMovieDetail(_ noti: Notification){
        guard let movieInfo: MovieDetail = noti.userInfo?["data"] as? MovieDetail  else{return}
        self.movie = movieInfo
    }
    
    @objc func didReceiveCommentList(_ noti: Notification){
        guard let commentList: [Comment] = noti.userInfo?["data"] as? [Comment] else{return}
        self.comments = commentList
        
        DispatchQueue.main.async {
            let range = NSMakeRange(0, self.commentTableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.commentTableView.reloadSections(sections as IndexSet, with: .automatic)
        }
    }
    
    @IBAction func touchUpCommentBtn(_ sender: UIButton) {
        let modalVC = CommentModalViewController()
        let tmpNavController: UINavigationController = UINavigationController(rootViewController: modalVC)
        modalVC.movieID = self.id
        self.present(tmpNavController, animated: true, completion: nil)
    }
}
