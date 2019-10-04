//
//  CommentModalViewController.swift
//  BoxOffice
//
//  Created by 전세호 on 02/10/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class CommentModalViewController: UIViewController {
    var movieID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.movieID!)
        print(":???")
    }
    
    private func initNavigation(){
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = Config.colors.themeColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "한줄평 작성"
        
        let leftBarBtn = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.dismissModal))
        let rightBarBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.addComment))
        self.navigationItem.leftBarButtonItem  = leftBarBtn
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    @objc func dismissModal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addComment(){
        
    }

}
