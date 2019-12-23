# ScalingCarousel

Scaling Carousel is easy usable pod to make your collection view have carousel effect as well scaling to full screen as well.



# Usage: 

1. Drag UICollectionViewController in storyboard, create a swift file for it and make it a subsclass of ` ScalingCarouselCollectionVC `, also conform to protocol ` ScalingCarouselProtocol `.

2. Create a UICollectionViewCell class and make it a subsclass of ` ScalingCarouselCVCell ` and connect folowing @IBOutlets
</br> a: ` mainScrollView `: (UIScrollView) the main scroll view in collection view cell class responsible for making cell full size and initial size.
</br> b: ` contentTopAnchor ` : (NSLayoutConstraint) the top anchor of view that is direct child of ` mainScrollView `.

3. Set ` ScalingCarouselProtocol ` delegate to self, in viewDidLoad method after ` super.viewDidLoad() ` call ` super.carouselDelegate = self `.

3. While conforming to ` ScalingCarouselProtocol ` provide value of following: 
    </br> a: ` reuseIdentifier `: (String) the reuse identifier of UICollectionViewCell
    </br> b: ` cellWidthScalePortrait `: (CGFloat 0 to 1) UICollectionViewCell width scale with respect to UIViewControllers View property for Portrait orientation.
    </br> c: ` cellHeightScalePortrait `: (CGFloat 0 to 1) UICollectionViewCell height scale with respect to UIViewControllers View property for Portrait orientation.
    </br> d: ` cellWidthScaleLandscape `: (CGFloat 0 to 1) UICollectionViewCell width scale with respect to UIViewControllers View property for Landscape orientation.
    </br> e: ` cellHeightScaleLandscape `: (CGFloat 0 to 1) UICollectionViewCell height scale with respect to UIViewControllers View property for Landscape orientation.
   </br></br>Also you can use following optional methds from " ScalingCarouselProtocol "
    </br> a:` cellDidShow(at indexPath: IndexPath) `: Calls when a specific cell shown to user.
    </br> b:` cellPreFetch(at indexPaths: [IndexPath]) `: From prefetchDataSource delegate, called for prefething of cell.
    </br> c:` cellCancelPreFetch(at indexPaths: [IndexPath]) `: From prefetchDataSource delegate, called for canceling of prefetch.
    
4. Implement methods of UICollectionViewDataSource i.e 
    </br> a:` collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) `: Provide your own DataSource count 
    </br> b:` collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) `: in this method instead of using  `collectionView.dequeueReusableCell(withReuseIdentifier: String, for: IndexPath) ` </br>use</br> ` super.collectionView(collectionView, cellForItemAt: indexPath) as! UICollectionViewCell ` <- (Collection Cell that is a subclass of ScalingCarouselCVCell) 
    
5. If using ` viewDidAppear(_ animated: Bool) ` and ` viewDidDisappear(_ animated: Bool) `, remember to use super call as well or else orientation change won't function properly.

6. Optional: You can use ` super.scrollToIndex?(IndexPath) ` to scroll UICollectionView to a specific IndexPath.


# Installation:

Using Cocoapods:

use ` pod 'ScalingCarousel', :git => 'https://github.com/ahsanateeq/ScalingCarousel.git' `
