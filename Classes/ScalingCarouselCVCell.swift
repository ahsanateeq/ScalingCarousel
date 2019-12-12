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
        var isFullScreen = false
        
        var makeFullScreen: ((Bool) -> ())?
        var initialFrame: CGRect?
        var initialCornerRadius: CGFloat?
        var topOffset: CGFloat?
        
        var collectionView: UICollectionView?
        
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
            
        }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isUserDragging = false
    }
        
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let newOffset = scrollView.contentOffset
//
//        print("New Offset Y: \(newOffset.y)")
//        print("ScrollView Frame Y: \(scrollView.frame.origin.y)")
//        print("ScrollView Content Top Inset: \(scrollView.contentInset.top)")
//        print("ScrollView Content Height: \(scrollView.contentSize.height)")
//        print("ScrollView Content TopAnchor: \(contentTopAnchor.constant)")
        
            if newOffset.x != prevOffset.x || !isUserDragging {
                prevOffset = newOffset
                return
            }
            
            if newOffset.y > prevOffset.y && !isFullScreen {
                isUserDragging = false
                makeFullScreen?(true)
                topOffset = newOffset.y
                
            } else if newOffset.y < (scrollView.frame.origin.y + contentTopAnchor.constant) && isFullScreen {
                if newOffset.y > prevOffset.y {
                    return
                }
                let newOff = CGPoint(x: newOffset.x, y: 0)
                scrollView.contentOffset = newOff
                isUserDragging = false
                makeFullScreen?(false)
            }
            
            prevOffset = newOffset
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
