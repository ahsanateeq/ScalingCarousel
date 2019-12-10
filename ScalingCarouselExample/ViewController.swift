//
//  ViewController.swift
//  ScalingCarouselExample
//
//  Created by Ahsan Ateeq on 10/12/2019.
//  Copyright © 2019 Proficeint Tech. All rights reserved.
//

import UIKit
import ScalingCarousel

class ViewController: ScalingCarouselCollectionVC {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        super.carouselDelegate = self
    }


}

extension ViewController: ScalingCarouselProtocol {
    func cellDidShow(at indexPath: IndexPath) {
        print("Cell Show At indexPath: \(indexPath)")
        
        if indexPath.item == 2 {
            super.scrollToIndex?(IndexPath(item: 4, section: 0))
        }
    }
}

