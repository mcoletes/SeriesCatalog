//
//  DetailInfoCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit

class DetailInfoCell: UITableViewCell, ReusableView, NibLoadableView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  func setup(title: String, description: String?) {
    titleLabel.text = title
    descriptionLabel.text = description
  }
}
