//
//  FavoriteSeriesModels.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

enum FavoriteSeriesStates {
  case idle
  case success([SeriesListCellModel])
}

enum FavoriteSortingOrder: Int {
  case insertion
  case ascending
  case descending
}
