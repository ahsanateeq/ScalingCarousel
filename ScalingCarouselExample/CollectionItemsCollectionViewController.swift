//
//  CollectionItemsCollectionViewController.swift
//  ScalingCarouselExample
//
//  Created by Ahsan Ateeq on 26/12/2019.
//  Copyright © 2019 Proficeint Tech. All rights reserved.
//

import UIKit


class CollectionItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
}

class FlowLayout: UICollectionViewFlowLayout {
    
    
    func setUp() {
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        let width = (self.collectionView?.frame.width)! / 3
        let height = (self.collectionView?.frame.width)! / 3
        
        itemSize = CGSize(width: width, height: height)
        
        self.invalidateLayout()
    }
}

class CollectionItemsCollectionViewController: UICollectionViewController {
    
    let layout = FlowLayout()
    
    let dataSourceCount = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        (collectionView.collectionViewLayout as! FlowLayout).setUp()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSourceCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! CollectionItemCollectionViewCell
    
        // Configure the cell
        
        cell.label.text = "Item No: \(indexPath.row + 1)"
    
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = ViewController.initialize(dataSourceCount: dataSourceCount, scrollToIndex: indexPath) {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    

}
