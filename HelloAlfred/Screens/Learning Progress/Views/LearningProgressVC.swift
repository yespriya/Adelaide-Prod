//
//  LearningProgressVC.swift
//  Adelaide Prod
//
//  Created by Prit  on 12/02/26.
//

import UIKit
import SwiftUI

class LearningProgressVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIHostingController(rootView: LearningProgressView())
        let learningProgressView = vc.view!
        learningProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(learningProgressView)
        
        NSLayoutConstraint.activate([
            learningProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            learningProgressView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            learningProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            learningProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
}
