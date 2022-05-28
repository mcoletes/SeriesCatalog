//
//  SeriesListCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import UIKit
import SDWebImage

struct SeriesListCellModel: Hashable {
  let id = UUID()
  let logoURL: URL?
  let title: String
  let genres: String
  let placeholderImage: UIImage? = UIImage.image(name: .loading)
  
  init(series: Series) {
    logoURL = series.image.medium
    title = series.name
    genres = series.genres.joined(separator: ", ")
  }
}

class SeriesListCell: UITableViewCell, NibLoadableView, ReusableView {
  
  @IBOutlet weak var logoView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var contentContainerView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentContainerView.addShadowAndCornerRadius()
    logoView.addCornerRadius()
  }
  
  func setup(with model: SeriesListCellModel) {
    logoView.sd_setImage(with: model.logoURL, placeholderImage: model.placeholderImage)
    titleLabel.text = model.title
    genreLabel.text = model.genres
  }
}
