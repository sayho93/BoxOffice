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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMovieDetail(_:)), name: Notification.DidReceiveMovieDetail, object: nil)
    }
    
    @objc func didReceiveMovieDetail(_ noti: Notification){
        
    }
}
