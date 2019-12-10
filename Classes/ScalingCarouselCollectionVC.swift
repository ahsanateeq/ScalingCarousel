//
//  CarouselScalingCollectionVC.swift
//  Carousel Practice
//
//  Created by Ahsan Ateeq on 06/12/2019.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

public protocol ScalingCarouselProtocol {
    func cellDidShow(at indexPath: IndexPath)
}


open class ScalingCarouselCollectionVC: UICollectionViewController {
    @IBInspectable var reuseIdentifier: String = "cell"
    @IBInspectable var cellWidthScale: CGFloat = 0.9
    @IBInspectable var cellHeightScale: CGFloat = 0.6
    
    var hiddenCells = [ScalingCarouselCVCell]()
    
    var prevOffset = CGPoint(x: 0, y: 0)
    var currentVisibleIndex = IndexPath(item: 0, section: 0) {
        didSet {
            self.carouselDelegate?.cellDidShow(at: currentVisibleIndex)
        }
    }
    var isUserDragging = false
    public var carouselDelegate: ScalingCarouselProtocol?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        setUpFlowLayout()
    }
    
    
    
    private func setUpFlowLayout() {
        let flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        let itemSize = CGSize(width: viewWidth * cellWidthScale, height: viewHeight * cellHeightScale)
        flow.itemSize = itemSize
        
        let xInsets = (self.view.frame.width - itemSize.width) / 2.0
        
        collectionView.contentInset.left = xInsets
        collectionView.contentInset.right = xInsets
        collectionView.collectionViewLayout = flow
    }
    
}

extension ScalingCarouselCollectionVC {
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ScalingCarouselCVCell
        cell.collectionView = collectionView
        setUpCellSize(collection: collectionView, cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    private func setUpCellSize(collection: UICollectionView, cell: ScalingCarouselCVCell, indexPath: IndexPath) {
        cell.makeFullScreen = { value in
            self.view.isUserInteractionEnabled = false
            
            let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: .zero)
            let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
            
            
            if value {
                self.hiddenCells = collection.visibleCells.map({ $0 as! ScalingCarouselCVCell }).filter({ $0 != cell })
                animator.addAnimations {
                    cell.expand(in: collection)
                    for c in self.hiddenCells {
                        c.hide(in: collection, selectedCellFrame: cell.frame)
                    }
                }
                animator.addCompletion { _ in
                    collection.isScrollEnabled = false
                    cell.isFullScreen = true
                }
            } else {
                animator.addAnimations {
                    cell.collapse()
                    for c in self.hiddenCells {
                        c.show()
                    }
                }
                
                animator.addCompletion { _ in
                    collection.isScrollEnabled = true
                    cell.isFullScreen = false
                    self.hiddenCells.removeAll()
                }
            }
            animator.addCompletion { _ in
                self.view.isUserInteractionEnabled = true
            }
            
            animator.startAnimation()
        }
    }
}


extension ScalingCarouselCollectionVC {
    override open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let newOffset = targetContentOffset.pointee
        
        if newOffset.x != prevOffset.x {
            
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            
            let index = (newOffset.x + scrollView.contentInset.left) / cellWidth
            let roundedIndex = round(index)
            
            
            let newOffX = roundedIndex * cellWidth - scrollView.contentInset.left
            let newOffY = scrollView.contentInset.top
            
            let newOff = CGPoint(x: newOffX, y: newOffY)
            
            targetContentOffset.pointee = newOff
            
            prevOffset = newOffset
            
            return
        }
        
    }
    
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let newOffset = scrollView.contentOffset
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        let index = (newOffset.x + scrollView.contentInset.left) / cellWidth
        let roundedIndex = round(index)
        currentVisibleIndex = IndexPath(item: Int(roundedIndex), section: 0)
    }
    
}
