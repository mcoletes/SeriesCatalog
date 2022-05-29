//
//  DetailInfoImageCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit
import SDWebImage

class DetailInfoImageCell: UITableViewCell, ReusableView, NibLoadableView {
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  func setup(imageUrl: URL?, title: String?, description: String?) {
    logoImage.sd_setImage(with: imageUrl, placeholderImage: UIImage.image(name: .loading))
    titleLabel.text = title
    descriptionLabel.text = description
  }
}