//
//  AppearanceManager.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation
import UIKit

protocol AppearanceManagerProtocol {
  func setupCommonAppearenceLayouts()
}

class AppearanceManager: AppearanceManagerProtocol {
  
  func setupCommonAppearenceLayouts() {
    setupNavigationBarAppearance()
    setupTableViewAppearance()
  }
  
  private func setupNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
    appearance.backgroundColor = .systemBackground
    
    let backButton = UIImage(systemName: "arrow.left")
    appearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
//  private func setupBarButtonAppearence() {
//    let buttonAppearance = UIBarButtonItemAppearance()
//    buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]
//  
//    UINavigationItem.appearence.standardAppearance?.buttonAppearance = buttonAppearance
//    navigationItem.compactAppearance?.buttonAppearance = buttonAppearance
//  }
  
  private func setupTableViewAppearance() {
    UITableView.appearance().sectionHeaderTopPadding = 0
  }
}
