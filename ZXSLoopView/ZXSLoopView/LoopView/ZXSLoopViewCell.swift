//
//  ZXSLoopViewCell.swift
//  图片轮播器
//
//  Created by 张晓珊 on 16/3/6.
//  Copyright © 2016年 张晓珊. All rights reserved.
//

import UIKit
import SDWebImage

class ZXSLoopViewCell: UICollectionViewCell {
    
    var imageUrl: NSURL? {
        didSet {
            imageView.sd_setImageWithURL(imageUrl, placeholderImage: nil, options: .RetryFailed)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = bounds
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var imageView = UIImageView()
}
