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
    setupTabBarAppearance()
    setupTableViewAppearance()
  }
  
  private func setupNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
    appearance.backgroundColor = .systemBackground
    
    let backButton = UIImage(systemName: "arrow.left")
    appearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)
    UINavigationBar.appearance().tintColor = .label
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
  private func setupTabBarAppearance() {

    let normal: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.secondaryLabel]
    let selected: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.label]

    UITabBarItem.appearance().setTitleTextAttributes(normal, for: .normal)
    UITabBarItem.appearance().setTitleTextAttributes(selected, for: .selected)

    UITabBar.appearance().backgroundColor = UIColor.secondarySystemBackground

  }
  
  private func setupTableViewAppearance() {
    UITableView.appearance().sectionHeaderTopPadding = 0
  }
}
