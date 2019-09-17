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
    private let refreshControl = UIRefreshControl()
    private var sortFlag = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MovieCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let movie: Movie = self.movies[indexPath.row]
        cell.thumbImg.image = UIImage()
        cell.info.text = movie.infoForTable
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
//                    if index.row == indexPath.row{
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBarVC = self.tabBarController as! MovieTabController
        self.movies = tabBarVC.movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func initNavigation(){
        self.navigationController?.navigationBar.tintColor = .white
        let barColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
}
