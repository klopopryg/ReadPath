//
//  ViewController.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

class DiscoverViewController: UIViewController {
    private let discoverViewModel: DiscoverViewModel
    
    init(discoverViewModel: DiscoverViewModel) {
        self.discoverViewModel = discoverViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

