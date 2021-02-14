//
//  CustomTableViewCell.swift
//  DiarySimbirSoft
//
//  Created by Булат on 22.01.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var caseLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(with post: PostModel) {
        caseLabel.text = post.title       
        timeLabel.text = "\(post.time):00 - \(post.time + 1):00"
    }

}
