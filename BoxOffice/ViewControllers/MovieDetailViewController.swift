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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    
    @IBOutlet weak var reservationRate: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var rateStar: UILabel!
    @IBOutlet weak var accumulate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetail(_:)), name: Notification.DidReceiveMovieDetail, object: nil)
        RequestHandler.getMovieDetail(id: self.id) {
            self.setData()
        }
        self.navigationItem.title = navigationTitle
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
                self.movieTitle.text = self.movie.title
                self.date.text = self.movie.date + "개봉"
                self.movieInfo.text = "\(self.movie.genre)/\(self.movie.duration)분"
                self.reservationRate.text = String(self.movie.reservationRate)
                self.rate.text = String(self.movie.userRating)
                self.accumulate.text = String(self.movie.audience)
                
                self.movieTitle.attributedText = self.makeAttributedString(movie: self.movie, label: self.movieTitle)
            }
        }
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
