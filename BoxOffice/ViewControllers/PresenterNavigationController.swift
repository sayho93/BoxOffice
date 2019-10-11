//
//  PresenterNavigationController.swift
//  BoxOffice
//
//  Created by 전세호 on 2019/10/11.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class PresenterNavigationController: UINavigationController {
    func initRefresh() {
        print("PresenterView initRefresh()")
        if let presenter = presentingViewController as? MovieDetailViewController {
            print("??")
            presenter.refreshTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
