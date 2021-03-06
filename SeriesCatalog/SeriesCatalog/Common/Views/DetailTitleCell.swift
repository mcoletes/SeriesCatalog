//
//  DetailTitleCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit

class DetailTitleCell: UITableViewCell, ReusableView, NibLoadableView {

  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var titleBackgroundView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleBackgroundView.addCornerRadius(titleBackgroundView.frame.size.height/2)
    logoImage.addCornerRadius(12)
  }
  
  func setup(title: String?, imageURL: URL?) {
    titleLabel.text = title
    backgroundImage.sdLoad(with: imageURL)
    logoImage.sdLoad(with: imageURL)
  }
}
