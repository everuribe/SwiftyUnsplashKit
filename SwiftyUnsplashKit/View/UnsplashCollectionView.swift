//
//  UnsplashCollectionView.swift
//  UnsplashTest
//
//  Created by Ever Uribe on 8/23/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import UIKit

class UnsplashCollectionView: UICollectionView {

    init(cellWidth: CGFloat, spaceBetweenCells: CGFloat) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth*0.8)
        layout.minimumInteritemSpacing = spaceBetweenCells
        layout.minimumLineSpacing = spaceBetweenCells
        
        //Margin on left/right of collectionView
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///Header view used for UnsplashCollectionView
class SectionHeader: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
