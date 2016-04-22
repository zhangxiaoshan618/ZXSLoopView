//
//  ZXSLoopView.swift
//  图片轮播器
//
//  Created by 张晓珊 on 16/3/6.
//  Copyright © 2016年 张晓珊. All rights reserved.
//

import UIKit

let kZXSLoopViewCellID = "ZXSLoopViewCellID"

class ZXSLoopView: UIView {
    
    var urls: [NSURL]? {
        didSet {
            stopTimer()
            self.collectionView.reloadData()
            self.pageView.numberOfPages = urls!.count
            startTimer()
        }
    }
    var selectedBlock: ((index: Int)->())?
    private weak var timer: NSTimer?
    
    init(frame: CGRect, urls: [NSURL], selectedBlock: ((index: Int)->())) {
        super.init(frame: frame)
        self.urls = urls
        self.selectedBlock = selectedBlock
        setUpUI()
        startTimer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpUI()
    }
    
    private func setUpUI() {
        prepareCollectionView()
        preparePageView()
    }
    
    private func preparePageView() {
        pageView.numberOfPages = urls!.count
        pageView.sizeToFit()
        let w = pageView.bounds.width
        let h = pageView.bounds.height
        let x = (self.bounds.width - w) * 0.5
        let y = self.bounds.height - 10 - h
        pageView.frame = CGRectMake(x, y, w, h)
        pageView.currentPageIndicatorTintColor = UIColor.redColor()
        pageView.pageIndicatorTintColor = UIColor.whiteColor()
        
        addSubview(pageView)
    }
    
    private func prepareCollectionView() {
        collectionView.frame = self.bounds
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(ZXSLoopViewCell.self, forCellWithReuseIdentifier: kZXSLoopViewCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        let indexPath = NSIndexPath(forRow: urls!.count * 100, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
    private func startTimer() {
        if urls!.count <= 1 || self.timer != nil {
            return
        }
        
        let timer = NSTimer(timeInterval: 3, target: self, selector: "fireTimer", userInfo: nil, repeats: true)
        self.timer = timer
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: 私有函数
    /// 时钟监听函数
    @objc private func fireTimer() {
        guard let indexPath = collectionView.indexPathsForVisibleItems().last else {
            return
        }
        
        let next = NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section)
        if next.item == urls!.count * 200 {
            return
        }
        collectionView.scrollToItemAtIndexPath(next, atScrollPosition: .Left, animated: true)
    }
    
    // MARK: - 懒加载
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ZXSLoopViewLayout())
    private lazy var pageView = UIPageControl()
}

extension ZXSLoopView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls!.count * (urls!.count == 1 ? 1 : 200)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kZXSLoopViewCellID, forIndexPath: indexPath) as! ZXSLoopViewCell
        cell.imageUrl = urls![indexPath.item % urls!.count]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard var offSet = collectionView.indexPathsForVisibleItems().last?.item else {
            return
        }
        pageView.currentPage = offSet % self.urls!.count
        if offSet == 0 || offSet == (self.collectionView.numberOfItemsInSection(0) - 1){
            offSet = self.urls!.count - (offSet == 0 ? 0 : 1)
            collectionView.contentOffset = CGPointMake(CGFloat(offSet) * collectionView.bounds.width, 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedBlock?(index: indexPath.row % urls!.count)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        stopTimer()
    }
}

