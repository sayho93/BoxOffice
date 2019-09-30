//
//  MovieDetailViewController.swift
//  BoxOffice
//
//  Created by 전세호 on 10/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var id: String!
    private var movie: MovieDetail!
    var navigationTitle: String!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetail(_:)), name: Notification.DidReceiveMovieDetail, object: nil)
        RequestHandler.getMovieDetail(id: self.id) {
            self.setData()
        }
        self.navigationItem.title = navigationTitle
        
        scrollView.translatesAutoresizingMaskIntoConstraints  = false
        for view in scrollView.subviews{
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
//        var contentRect = CGRect.zero
//
//        for view in scrollView.subviews {
//           contentRect = contentRect.union(view.frame)
//        }
//        scrollView.contentSize = contentRect.size
//        print(contentRect.size)
        self.scrollView.isScrollEnabled = true
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
}
