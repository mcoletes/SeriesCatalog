//
//  EpisodeDetailLogoTitleCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit

class EpisodeDetailLogoTitleCell: UITableViewCell, ReusableView, NibLoadableView {

  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setup(logoUrl: URL?, title: String?) {
    logoImage.sdLoad(with: logoUrl)
    titleLabel.text = title
  }
}
