//
//  CommentTableViewCell.swift
//  BoxOffice
//
//  Created by 전세호 on 01/10/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var content: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
