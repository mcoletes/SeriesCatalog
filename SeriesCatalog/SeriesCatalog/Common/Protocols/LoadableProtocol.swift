//
//  LoadableProtocol.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit

protocol LoadableProtocol {
    func showLoading()
    func hideLoading()
}

extension LoadableProtocol where Self: UIViewController {
    
    func showLoading() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        loadingView.animate()
    }
    
    func hideLoading() {
      view.subviews.filter({ $0 is LoadingView}).forEach({$0.removeFromSuperview()})
    }
}


class LoadingView: UIView {
  private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func layoutSubviews() {
        super.layoutSubviews()
      backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.9)
        addCornerRadius(5)
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    func animate() {
        activityIndicatorView.startAnimating()
    }
}
