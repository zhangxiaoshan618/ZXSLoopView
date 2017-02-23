//
//  ZXSLoopViewLayout.swift
//  图片轮播器
//
//  Created by 张晓珊 on 16/3/6.
//  Copyright © 2016年 张晓珊. All rights reserved.
//

import UIKit

class ZXSLoopViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
