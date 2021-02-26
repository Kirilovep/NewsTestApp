//
//  SourcesTableViewCell.swift
//  NewsTestApp
//
//  Created by shizo663 on 26.02.2021.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hiddenView(true)
    }
    
    func hiddenView(_ hidden: Bool) {
        nameLabel.isHidden = hidden
        descriptionLabel.isHidden = hidden
        languageLabel.isHidden = hidden
        countryLabel.isHidden = hidden
        
    }
    
    func configure(_ result: Sources) {
        nameLabel.text = result.name
        descriptionLabel.text = result.description
        languageLabel.text = result.language
        countryLabel.text = result.country
        hiddenView(false)
    }
    
    
}
