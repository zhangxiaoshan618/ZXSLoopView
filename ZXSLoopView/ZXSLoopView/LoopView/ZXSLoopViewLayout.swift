//
//  ZXSLoopViewLayout.swift
//  图片轮播器
//
//  Created by 张晓珊 on 16/3/6.
//  Copyright © 2016年 张晓珊. All rights reserved.
//

import UIKit

class ZXSLoopViewLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        super.prepareLayout()
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
