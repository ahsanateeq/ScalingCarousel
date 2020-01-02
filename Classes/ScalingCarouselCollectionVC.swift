//
//  CarouselScalingCollectionVC.swift
//  Carousel Practice
//
//  Created by Ahsan Ateeq on 06/12/2019.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

public protocol ScalingCarouselProtocol {
    var reuseIdentifier: String {get set}
    var cellWidthScalePortrait: CGFloat {get set}
    var cellHeightScalePortrait: CGFloat {get set}
    var cellWidthScaleLandscape: CGFloat {get set}
    var cellHeightScaleLandscape: CGFloat {get set}
    
    func cellDidShow(at indexPath: IndexPath)
    func cellPreFetch(at indexPaths: [IndexPath])
    func cellCancelPreFetch(at indexPaths: [IndexPath])
}



extension ScalingCarouselProtocol {
    func cellDidShow(at indexPath: IndexPath) {}
    func cellPreFetch(at indexPaths: [IndexPath]) {}
    func cellCancelPreFetch(at indexPaths: [IndexPath]) {}
}


open class ScalingCarouselCollectionVC: UICollectionViewController {
    
    var hiddenCells = [ScalingCarouselCVCell]()
    
    var prevOffset = CGPoint(x: 0, y: 0)
    var currentVisibleIndex = IndexPath(item: 0, section: 0) {
        didSet {
            self.enableScrollForContent(at: currentVisibleIndex)
            self.carouselDelegate?.cellDidShow(at: currentVisibleIndex)
        }
    }
    var isUserDragging = false
    public var carouselDelegate: ScalingCarouselProtocol? {
        didSet {
            DispatchQueue.main.async {
                self.setUpFlowLayout()
            }
        }
    }
    public var scrollToIndex: ((IndexPath, Bool) -> ())!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        
        setUpFlowLayout()
        self.scrollToIndex = {
            self.setUpScrollToIndex(index: $0, animated: $1)
        }
    }
    
    private func setUpScrollToIndex(index: IndexPath, animated: Bool) {
        if index == self.currentVisibleIndex {
            self.enableScrollForContent(at: index)
            self.carouselDelegate?.cellDidShow(at: index)
        }
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
    }
    
    private func enableScrollForContent(at index: IndexPath) {
        guard let cell = self.collectionView.cellForItem(at: index) as? ScalingCarouselCVCell else {
            return
        }
        cell.mainScrollView.isScrollEnabled = true
        cell.setScrollContentSize()
    }
    
    private func setUpFlowLayout() {
        let flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        
        
        
        var orientation = UIApplication.shared.statusBarOrientation

        if #available(iOS 13.0, *) {
            if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
                orientation = interfaceOrientation
            }
        }
        
        guard let child = self.carouselDelegate else { return }
        
        let cellWidthScale = orientation == .landscapeLeft || orientation == .landscapeRight ? child.cellWidthScaleLandscape : child.cellWidthScalePortrait
        let cellHeightScale = orientation == .landscapeLeft || orientation == .landscapeRight ? child.cellHeightScaleLandscape : child.cellHeightScalePortrait
        
        let itemSize = CGSize(width: viewWidth * cellWidthScale, height: viewHeight * cellHeightScale)
        flow.itemSize = itemSize
        
        let xInsets = (self.view.frame.width - itemSize.width) / 2.0
        
        collectionView.contentInset.left = xInsets
        collectionView.contentInset.right = xInsets
        collectionView.collectionViewLayout = flow
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        self.enableScrollForContent(at: currentVisibleIndex)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated(){
        setUpFlowLayout()
        self.setUpScrollToIndex(index: currentVisibleIndex, animated: false)
    }
    
}

extension ScalingCarouselCollectionVC {
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let child = self.carouselDelegate else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: child.reuseIdentifier, for: indexPath) as! ScalingCarouselCVCell
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
                cell.animationCompleted = true
            }
            
            animator.startAnimation()
        }
    }
}


extension ScalingCarouselCollectionVC {
    
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let cell = collectionView.cellForItem(at: currentVisibleIndex) as? ScalingCarouselCVCell else { return }
        cell.mainScrollView.isScrollEnabled = false
    }
    
    override open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.decelerationRate = .normal
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
           
            
            self.prevOffset = newOffset
            
            return
        }
        
    }
    
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCurrentVisibleCellIndex(scrollView)
    }
    
    open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setCurrentVisibleCellIndex(scrollView)
    }
    
    private func setCurrentVisibleCellIndex(_ scrollView: UIScrollView) {
        let newOffset = scrollView.contentOffset
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        let index = (newOffset.x + scrollView.contentInset.left) / cellWidth
        let roundedIndex = round(index)
        currentVisibleIndex = IndexPath(item: Int(roundedIndex), section: 0)
        
        
    }
}

extension ScalingCarouselCollectionVC: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        self.carouselDelegate?.cellPreFetch(at: indexPaths)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        self.carouselDelegate?.cellCancelPreFetch(at: indexPaths)
    }
}
