//
//  CasedescripionViewController.swift
//  DiarySimbirSoft
//
//  Created by Булат on 23.01.2021.
//

import UIKit

typealias EditPostHandler = (EventModel) -> Void

class CasedescripionViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var post:EventModel?
    var onEditPostHandler: EditPostHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = post?.time.description
        titleLabel.text = post?.title
        descriptionLabel.text = post?.specification
    }
}
