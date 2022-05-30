//
//  PeopleListCell.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit

class PeopleListCell: UICollectionViewCell, NibLoadableView, ReusableView {

  @IBOutlet weak var personImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  func setup(personURL: URL?, name: String?) {
    personImage.sdLoad(with: personURL)
    nameLabel.text = name
  }
}
