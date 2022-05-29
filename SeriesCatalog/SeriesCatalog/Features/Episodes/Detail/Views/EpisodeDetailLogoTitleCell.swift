//
//  EpisodeDetailLogoTitleCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit
import SDWebImage

class EpisodeDetailLogoTitleCell: UITableViewCell, ReusableView, NibLoadableView {

  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setup(logoUrl: URL?, title: String?) {
    logoImage.sd_setImage(with: logoUrl, placeholderImage: UIImage.image(name: .loading))
    titleLabel.text = title
  }
}
