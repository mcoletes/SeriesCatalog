//
//  TabbarController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit

class TabBarController: UITabBarController {
    
  private let viewModel: TabBarViewModelProtocol
  
  init(viewModel: TabBarViewModelProtocol = TabBarViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createTabs()
    delegate = self
  }
  
  private func createTabs() {
    let tabs = viewModel.getMenuItems()
    self.viewControllers = tabs.map({ return self.createTabViewController(model: $0.model)})
  }
  
  func createTabViewController(model: TabBarModel) -> UIViewController {
    model.viewController.title = model.title
    let image = UIImage(systemName: model.image)
    let defaultImage = image?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
    let selectedImage = image?.withTintColor(.label, renderingMode: .alwaysOriginal)
    let navigationController = UINavigationController(rootViewController: model.viewController)
    navigationController.tabBarItem = UITabBarItem(title: model.title,
                                 image: defaultImage,
                                 selectedImage: selectedImage)
    return navigationController
  }
}

extension TabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    guard let fromView = selectedViewController?.view,
            let toView = viewController.view else { return false }
    if fromView != toView {
      UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCrossDissolve], completion: nil)
    }
    return true
  }
}

