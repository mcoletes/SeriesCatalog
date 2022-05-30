//
//  FavoritesSeriesManager.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

protocol FavoritesSeriesManagerProtocol {
  func isFavorite(id: Int) -> Bool
  func deleteFavorite(id: Int)
  func addFavorite(series: Series)
  func getFavorites() -> [Series]
}
class FavoritesSeriesManager: FavoritesSeriesManagerProtocol {
  
  private let favoriteSeriesDefaults = UserDefaultsItem<[Series]>("series")
  var favoriteSeries: [Series] {
    get { favoriteSeriesDefaults.get() ?? [] }
    set { favoriteSeriesDefaults.set(newValue) }
  }
  
  func isFavorite(id: Int) -> Bool {
    return favoriteSeries.contains(where: {$0.id == id})
  }
  
  func deleteFavorite(id: Int) {
    guard let index = favoriteSeries.firstIndex(where: {$0.id == id })  else {
      return
    }
    var seriesTemp = favoriteSeries
    seriesTemp.remove(at: index)
    self.favoriteSeries = seriesTemp
  }
  
  func addFavorite(series: Series) {
    guard favoriteSeries.firstIndex(where: {$0.id == series.id }) == nil else {
      return
    }
    var seriesTemp = favoriteSeries
    seriesTemp.append(series)
    favoriteSeries = seriesTemp
  }
  
  func getFavorites() -> [Series] {
    return favoriteSeries
  }
}
