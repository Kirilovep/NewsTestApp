//
//  NewsTableViewCell.swift
//  NewsTestApp
//
//  Created by shizo663 on 25.02.2021.
//

import UIKit
import Kingfisher
class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hiddenView(true)
    }
    
    func configure(_ result: Article) {
        titleLabel.text = result.title
        descriptionLabel.text = result.description
        sourceNameLabel.text = result.source?.name
        authorLabel.text = result.author
        
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let outDateFormatter = DateFormatter()
        outDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        outDateFormatter.dateFormat = "HH:mm"
        
        if let date = inFormatter.date(from: result.publishedAt ?? " ") {
            let outStr = outDateFormatter.string(from: date)
            timeLabel.text = outStr
        }
        
        if let url = URL(string: result.urlToImage ?? "") {
            newsImageView.kf.indicatorType = .activity
            newsImageView.kf.setImage(with: url)
        } else {
            newsImageView.image = UIImage(named: "noImage")
        }
        hiddenView(false)
    }
    
    func hiddenView(_ hidden: Bool) {
        timeLabel.isHidden = hidden
        titleLabel.isHidden = hidden
        descriptionLabel.isHidden = hidden
        authorLabel?.isHidden = hidden
        sourceNameLabel.isHidden = hidden
        
    }
}
