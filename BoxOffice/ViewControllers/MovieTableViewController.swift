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
    private let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
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
    
    func makeAttributedString(movie: Movie, cell: MovieTableViewCell) -> NSMutableAttributedString{
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
        alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: style)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            print("OK pressed")
            guard let first = alertController.textFields![0].text else{return}
            guard let last = alertController.textFields?.last!.text else{return}
//            self.ID = first
//            self.password = last
            print(first)
            print(last)
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        let handler: (UIAlertAction) -> Void
        handler = {(action: UIAlertAction) in
            print("action pressed \(action.title ?? "")")
        }
        
        let someAction: UIAlertAction = UIAlertAction(title: "Some", style: UIAlertAction.Style.destructive, handler: handler)
        let anotherAction: UIAlertAction = UIAlertAction(title: "Another", style: UIAlertAction.Style.default, handler: handler)
        alertController.addAction(someAction)
        alertController.addAction(anotherAction)
        
        if style == UIAlertController.Style.alert{
            alertController.addTextField { (field: UITextField) in
                field.placeholder = "ID"
                field.textColor = .darkText
            }
            alertController.addTextField { (field: UITextField) in
                field.placeholder = "password"
                field.textColor = .darkText
            }
        }
        
        self.present(alertController, animated: true, completion: {
            print("Alert controller shown")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMovieList(_:)), name: Notification.DidReceiveMovieList, object: nil)
        RequestHandler.getMovieList{return}
        initRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    private func initNavigation(){
        self.navigationController?.navigationBar.tintColor = .white
        let barColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.tabBarController?.tabBar.barTintColor = barColor
        self.tabBarController?.tabBar.tintColor = .white
        self.tabBarController?.tabBar.unselectedItemTintColor = .lightText
    }
    
    private func initRefresh(){
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: nil)
    }
    
    @objc private func refreshData(_ sender: Any){
        RequestHandler.getMovieList {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    @objc func didReceiveMovieList(_ noti: Notification){
        guard let movies: [Movie] = noti.userInfo?["data"] as? [Movie] else{return}
        self.movies = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

