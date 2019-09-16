//
//  ViewController.swift
//  BoxOffice
//
//  Created by 전세호 on 05/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier: String = "movieTableCell"
    var movies: [Movie] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        let movie: Movie = self.movies[indexPath.row]
        cell.thumbImg.image = UIImage()
        cell.title.text = movie.title
        cell.info.text = movie.infoForTable
        cell.date.text = movie.date
        
        DispatchQueue.global().async {
            guard let thumbURL: URL = URL(string: movie.thumb) else{return}
            guard let thumbData: Data = try? Data(contentsOf: thumbURL) else{return}
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell){
                    if index.row == indexPath.row{
                        cell.thumbImg.image = UIImage(data: thumbData)
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = movies[indexPath.row]
        print(data)
        self.performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navInit()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieList(_:)), name: Notification.DidReceiveMovieList, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationItem.title = countryName
        RequestHandler.getMovieList()
    }
    
    @objc func didReceiveMovieList(_ noti: Notification){
        guard let movies: [Movie] = noti.userInfo?["data"] as? [Movie] else{return}
        self.movies = movies
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func navInit(){
        self.navigationController?.navigationBar.tintColor = .white
        let barColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.tabBarController?.tabBar.barTintColor = barColor
        self.tabBarController?.tabBar.tintColor = .white
        self.tabBarController?.tabBar.unselectedItemTintColor = .lightText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetailSegue"{
            if let index = self.tableView.indexPathForSelectedRow?.row{
                let row = movies[index]
                guard let nextViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController else{
                    return
                }
                nextViewController.id = row.id
            }
        }else{
            print("???")
        }
    }


}

