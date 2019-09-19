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
    
    @IBAction func touchUpSettingBtn(){
        self.showAlertController(style: .actionSheet)
    }
    
    func showAlertController(style: UIAlertController.Style){
        let alertController: UIAlertController
        alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: style)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let handler: (Int) -> Void = {(type: Int) in
            self.tabBarVC.sortFlag = type
//            self.sortFlag = type
            self.setNavbarTitle()
            RequestHandler.getMovieList(type: type, callback: {
                self.tabBarVC.movies = self.movies
            })
        }
        
        let reservationRate: UIAlertAction = UIAlertAction(title: "예매율", style: UIAlertAction.Style.default, handler: { action in
            handler(0)
        })
        let curation: UIAlertAction = UIAlertAction(title: "큐레이션", style: UIAlertAction.Style.default, handler: {action in
            handler(1)
        })
        let date: UIAlertAction = UIAlertAction(title: "개봉일", style: UIAlertAction.Style.default, handler: {action in
            handler(2)
        })
        alertController.addAction(reservationRate)
        alertController.addAction(curation)
        alertController.addAction(date)
        
        self.present(alertController, animated: true, completion: {
            print("Alert controller shown")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieList(_:)), name: Notification.DidReceiveMovieList, object: nil)
        self.tabBarVC = self.tabBarController as? MovieTabController
        RequestHandler.getMovieList{
            self.tabBarVC.movies = self.movies
        }
        initRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let index = self.collectionView.indexPathsForSelectedItems{
            for idx in index{
                self.collectionView.deselectItem(at: idx, animated: true)
            }
        }
        setNavbarTitle()
    }
    
    private func setNavbarTitle(){
        var titleTxt: String
        switch tabBarVC.sortFlag {
        case 0:
            titleTxt = "예매율순"
        case 1:
            titleTxt = "큐레이션"
        case 2:
            titleTxt = "개봉일순"
        default:
            titleTxt = "table"
        }
        
        self.navigationController?.navigationBar.topItem?.title = titleTxt
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
        RequestHandler.getMovieList(type: self.tabBarVC.sortFlag) {
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
