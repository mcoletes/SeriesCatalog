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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    logoImage.addCornerRadius()
  }
  
  func setup(imageUrl: URL?, title: String?, description: String?) {
    logoImage.sdLoad(with: imageUrl)
    titleLabel.text = title
    descriptionLabel.text = description
  }
}
