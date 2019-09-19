//
//  MovieCollectionViewController.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier: String = "movieCollectionCell"
    var movies: [Movie] = []
    private var flowLayout: UICollectionViewFlowLayout!
    private let refreshControl = UIRefreshControl()
    private var sortFlag = 0
    private var tabBarVC: MovieTabController!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MovieCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let movie: Movie = self.movies[indexPath.row]
        cell.thumbImg.image = UIImage()
        cell.info.text = movie.infoForCollection
        cell.date.text = movie.date
        let mutableString = makeAttributedString(movie: movie, cell: cell)
        cell.title.attributedText = mutableString
        
        DispatchQueue.global().async {
            guard let thumbURL: URL = URL(string: movie.thumb) else{return}
            guard let thumbData: Data = try? Data(contentsOf: thumbURL) else{return}
            DispatchQueue.main.async {
                cell.thumbImg.image = UIImage(data: thumbData)
                cell.setNeedsLayout()
                
//                if let index: IndexPath = collectionView.indexPath(for: cell){
//                    if index.row == indexPath.row && index.section == indexPath.section{
//                        cell.thumbImg.image = UIImage(data: thumbData)
//                        cell.setNeedsLayout()
//                    }
//                }
            }
        }
        return cell
    }
    
    func makeAttributedString(movie: Movie, cell: MovieCollectionViewCell) -> NSMutableAttributedString{
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
        
        attachment.bounds = CGRect(x: 0, y: (cell.title.font.capHeight - (attachment.image?.size.height)!).rounded() / 2, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
        
        let imageAttribute = NSAttributedString(attachment: attachment)
        mutableString.append(imageAttribute)
        
        return mutableString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieList(_:)), name: Notification.DidReceiveMovieList, object: nil)
        RequestHandler.getMovieList{
            self.tabBarVC = self.tabBarController as? MovieTabController
            self.tabBarVC.movies = self.movies
        }
        initRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBarVC = self.tabBarController as! MovieTabController
        self.movies = tabBarVC.movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func initCollectionView(){
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: halfWidth - 5, height: halfWidth * 1.6)
        self.collectionView.collectionViewLayout = flowLayout
    }

    private func initNavigation(){
        self.navigationController?.navigationBar.tintColor = .white
        let barColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func initRefresh(){
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
    
    @objc private func refreshData(_ sender: Any){
        RequestHandler.getMovieList(type: self.sortFlag) {
            self.tabBarVC.movies = self.movies
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    @objc func didReceiveMovieList(_ noti: Notification){
        guard let movies: [Movie] = noti.userInfo?["data"] as? [Movie] else{return}
        self.movies = movies
        DispatchQueue.main.async {
            let range = NSMakeRange(0, self.collectionView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.collectionView.reloadSections(sections as IndexSet)
        }
    }
    
}
