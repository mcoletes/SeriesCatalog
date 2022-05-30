//
//  TabBarModels.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation
import UIKit

struct TabBarModel {
  let title: String
  let image: String
  let viewController: UIViewController
}

enum TabBarTabs: CaseIterable {
  case series
  case favorites
  case people

  var model: TabBarModel {
    switch self {
    case .series:
      return TabBarModel(title: "Series",
                         image: Constants.Icons.photo,
                         viewController: SeriesTableViewController())
    case .favorites:
      return TabBarModel(title: "Favorites",
                         image: Constants.Icons.heartFilled,
                         viewController: FavoritesViewController())
    case .people:
      return TabBarModel(title: "People",
                         image: Constants.Icons.person,
                         viewController: PeopleSearchViewController())
    }
  }
}
