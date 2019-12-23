//
//  CarouselScalingCVCell.swift
//  Carousel Practice
//
//  Created by Ahsan Ateeq on 06/12/2019.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

protocol ExpandableCellProtocol {
    func hide(in collection: UICollectionView, selectedCellFrame frame: CGRect)
    func show()
    func expand(in collection: UICollectionView)
    func collapse()
}

open class ScalingCarouselCVCell: UICollectionViewCell {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentTopAnchor: NSLayoutConstraint!
    var isUserDragging = false
    var prevOffset = CGPoint(x: 0, y: 0)
    var isFullScreen = false {
        didSet {
            self.setScrollContentSize()
        }
    }
    
    
    var animationCompleted: Bool = true
    var scrollingUp: Bool = false
    
    var makeFullScreen: ((Bool) -> ())?
    var initialFrame: CGRect?
    var initialCornerRadius: CGFloat?
    var topOffset: CGFloat?
    
    var collectionView: UICollectionView?
    
    func setScrollContentSize() {
        if mainScrollView.contentSize.height < mainScrollView.frame.height {
            UIView.animate(withDuration: 0.1) {
                self.mainScrollView.contentSize.height = self.mainScrollView.frame.height + 1
                self.mainScrollView.showsVerticalScrollIndicator = true
            }
        }
    }
        
    override open func awakeFromNib() {
            preSetUp()
        }
        
    override open func prepareForReuse() {
            preSetUp()
        }
        
        private func preSetUp() {
            isUserDragging = false
            prevOffset = CGPoint(x: 0, y: 0)
            isFullScreen = false
            
            self.contentView.layer.cornerRadius = 10.0
            self.contentView.layer.masksToBounds = true
            self.contentView.clipsToBounds = true
            self.mainScrollView.delegate = self
            layoutIfNeeded()
        }
        
    }


extension ScalingCarouselCVCell: UIScrollViewDelegate {
    
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            isUserDragging = true
        }
        
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//            let offset = scrollView.contentOffset
//            print("New Offset Y: \(offset.y)")
//            print("Prev Offset Y: \(prevOffset.y)")
        }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
//        print("Did end drag up: \(offset.y > prevOffset.y)")
        isUserDragging = false
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingUp = false
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollingUp = false
    }
        
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newOffset = scrollView.contentOffset
       
        
        print("IsScrollingUp: \(scrollingUp)")
//        print(newOffset)
//
//        print("New Offset Y: \(newOffset.y)")
//        print("ScrollView Frame Y: \(scrollView.frame.origin.y)")
//        print("ScrollView Content Top Inset: \(scrollView.contentInset.top)")
//        print("ScrollView Content Height: \(scrollView.contentSize.height)")
//        print("ScrollView Content TopAnchor: \(contentTopAnchor.constant)")
        
        let offSetXNotEqual = newOffset.x != prevOffset.x
        let contentReachedTop = newOffset.y < (scrollView.frame.origin.y + contentTopAnchor.constant)
        let contentScrollingUp = newOffset.y > prevOffset.y
        let contentScrollingDown = newOffset.y < prevOffset.y
//        scrollingUp = newOffset.y > prevOffset.y
        
        if contentScrollingDown && scrollingUp && isUserDragging {
            scrollingUp = false
        }
        
        if (offSetXNotEqual || !isUserDragging){
            prevOffset = newOffset
            
            
            if contentReachedTop && contentScrollingDown && isFullScreen && animationCompleted
                && !scrollingUp {
                makeItemInitialSize(scrollView, newOffset)
            }
            
            return
        }
            
            if contentScrollingUp  {
                
                scrollingUp = true
                
                if !isFullScreen && animationCompleted
                {
                    makeItemFullSize(newOffset)
                }
                
                
            } else if contentReachedTop && isFullScreen && animationCompleted
            {
                if newOffset.y > prevOffset.y {
                    return
                }
                makeItemInitialSize(scrollView, newOffset)
            }
            
            prevOffset = newOffset
        }
    
    private func makeItemFullSize(_ newOffset: CGPoint) {
        animationCompleted = false
        mainScrollView.showsVerticalScrollIndicator = false
        isUserDragging = false
        makeFullScreen?(true)
        topOffset = newOffset.y
    }
    
    private func makeItemInitialSize(_ scrollView: UIScrollView, _ newOffset: CGPoint) {
        animationCompleted = false
        mainScrollView.showsVerticalScrollIndicator = false
        isUserDragging = false
        let newOff = CGPoint(x: newOffset.x, y: 0)
        scrollView.contentOffset = newOff
        makeFullScreen?(false)
    }
}

extension ScalingCarouselCVCell: ExpandableCellProtocol {
        func hide(in collection: UICollectionView, selectedCellFrame cellFrame: CGRect) {
            self.initialFrame = self.frame
            
            let currentX = self.frame.origin.x
            var newX: CGFloat
            
            if currentX < cellFrame.origin.x {
                let offset = cellFrame.origin.x - currentX
                newX = collection.contentOffset.x - offset - collection.contentInset.left
            } else {
                let offset = currentX - cellFrame.maxX
                newX = collection.contentOffset.x + collection.frame.width + offset + collection.contentInset.left
            }
            
            self.frame.origin.x = newX
            
            layoutIfNeeded()
        }
        
        func show() {
            self.frame = initialFrame ?? frame
            initialFrame = nil
            layoutIfNeeded()
        }
        
        func expand(in collection: UICollectionView) {
            initialFrame = frame
            initialCornerRadius = self.contentView.layer.cornerRadius
            self.contentView.layer.cornerRadius = 0
            
            let newX = collection.contentOffset.x
            let newY = collection.frame.origin.y
            
            let newWidth = collection.frame.width
            let newHeight = collection.frame.height
            
            let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            
            frame = newFrame
            
            layoutIfNeeded()
        }
        
        func collapse() {
            self.frame = initialFrame ?? frame
            self.contentView.layer.cornerRadius = initialCornerRadius ?? contentView.layer.cornerRadius
            
            initialFrame = nil
            initialCornerRadius = nil
            
            layoutIfNeeded()
        }
    }
