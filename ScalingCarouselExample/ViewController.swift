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
    
    @IBOutlet weak var blurrView: UIVisualEffectView!
    
    @IBAction func dismissVC(_ sender: UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var dataSourceCount: Int = 0 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var toIndex: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
//            super.scrollToIndex?(toIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.carouselDelegate = self
        addBlurrView()
    }

    
    private func addBlurrView() {
        self.view.addSubview(blurrView)
        blurrView.translatesAutoresizingMaskIntoConstraints = false
        self.view.bringSubviewToFront(self.collectionView)
        NSLayoutConstraint.activate([
            blurrView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurrView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            blurrView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blurrView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
    }
    
    private func removeBlurrView() {
        self.blurrView.removeFromSuperview()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceCount
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.scrollToIndex(toIndex, false)
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
        
        
    }
    
}

extension ViewController {
    class func initialize(dataSourceCount: Int, scrollToIndex index: IndexPath) -> ViewController? {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "scalingCarouselVC") as? ViewController
        vc?.dataSourceCount = dataSourceCount
        vc?.toIndex = index
        return vc
        
    }
}

