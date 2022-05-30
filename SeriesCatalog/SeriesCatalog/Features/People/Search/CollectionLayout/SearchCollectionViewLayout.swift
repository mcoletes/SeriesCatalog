//
//  SearchCollectionViewLayout.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation
import UIKit

class SearchCollectionViewLayout {
  func getLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { _, environment in
      
      let itemSize = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(self.getSize(for: environment)),
        heightDimension: NSCollectionLayoutDimension.estimated(200))
        
        let layoutSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
  }
  
  func getSize(for environment: NSCollectionLayoutEnvironment) -> CGFloat {
    let isIpad = environment.traitCollection.userInterfaceIdiom == .pad
    var itemsPerRowPortrait: CGFloat = 3
    if isIpad {
      itemsPerRowPortrait += 1
    }
    return environment.traitCollection.horizontalSizeClass == .regular ? 1/(itemsPerRowPortrait + 1) : 1/itemsPerRowPortrait
  }
}
