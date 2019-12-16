//
//  ViewController.swift
//  ScalingCarouselExample
//
//  Created by Ahsan Ateeq on 10/12/2019.
//  Copyright © 2019 Proficeint Tech. All rights reserved.
//

import UIKit
import ScalingCarousel

class ViewController: ScalingCarouselCollectionVC, ScalingCarouselProtocol {
    
    var cellWidthScalePortrait: CGFloat = 0.9
    var cellHeightScalePortrait: CGFloat = 0.6
    var cellWidthScaleLandscape: CGFloat = 0.6
    var cellHeightScaleLandscape: CGFloat = 0.9
    var reuseIdentifier: String = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.carouselDelegate = self
    }


}

extension ViewController  {
    func cellPreFetch(at indexPaths: [IndexPath]) {
        print("Cell Prefetch At: \(indexPaths)")
    }
    
    func cellCancelPreFetch(at indexPaths: [IndexPath]) {
        print("Cell Cancel Prefetch At: \(indexPaths)")
    }
    
    func cellDidShow(at indexPath: IndexPath) {
        print("Cell Show At indexPath: \(indexPath)")
        
        if indexPath.item == 2 {
            super.scrollToIndex?(IndexPath(item: 4, section: 0))
        }
    }
    
    
}

