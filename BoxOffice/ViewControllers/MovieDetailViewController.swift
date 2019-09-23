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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetail(_:)), name: Notification.DidReceiveMovieDetail, object: nil)
        RequestHandler.getMovieDetail(id: self.id)
        self.navigationItem.title = navigationTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func didReceiveMovieDetail(_ noti: Notification){
        guard let movieInfo: MovieDetail = noti.userInfo?["data"] as? MovieDetail  else{return}
        self.movie = movieInfo
    }
}
