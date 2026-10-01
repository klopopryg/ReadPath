//
//  LoadingFooterView.swift
//  ReadPath
//
//  Created by Егор on 01.10.2026.
//

import UIKit

final class LoadingFooterView: UICollectionReusableView {
    static let reusableIdentifier = "loadingFooterView"
    private let footerView = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        footerView.startAnimating()
    }
    
    func stopAnimating() {
        footerView.stopAnimating()
    }
    
    private func setupUI() {
        addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            footerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
