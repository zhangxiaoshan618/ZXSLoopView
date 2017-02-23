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
    
    var urls: [URL]? {
        didSet {
            stopTimer()
            self.collectionView.reloadData()
            self.pageView.numberOfPages = urls!.count
            startTimer()
        }
    }
    var selectedBlock: ((_ index: Int)->())?
    fileprivate weak var timer: Timer?
    
    init(frame: CGRect, urls: [URL], selectedBlock: @escaping ((_ index: Int)->())) {
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
    
    fileprivate func setUpUI() {
        prepareCollectionView()
        preparePageView()
    }
    
    fileprivate func preparePageView() {
        pageView.numberOfPages = urls!.count
        pageView.sizeToFit()
        let w = pageView.bounds.width
        let h = pageView.bounds.height
        let x = (self.bounds.width - w) * 0.5
        let y = self.bounds.height - 10 - h
        pageView.frame = CGRect(x: x, y: y, width: w, height: h)
        pageView.currentPageIndicatorTintColor = UIColor.red
        pageView.pageIndicatorTintColor = UIColor.white
        
        addSubview(pageView)
    }
    
    fileprivate func prepareCollectionView() {
        collectionView.frame = self.bounds
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ZXSLoopViewCell.self, forCellWithReuseIdentifier: kZXSLoopViewCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        let indexPath = IndexPath(row: urls!.count * 100, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    fileprivate func startTimer() {
        if urls!.count <= 1 || self.timer != nil {
            return
        }
        
        let timer = Timer(timeInterval: 3, target: self, selector: #selector(ZXSLoopView.fireTimer), userInfo: nil, repeats: true)
        self.timer = timer
        
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: 私有函数
    /// 时钟监听函数
    @objc fileprivate func fireTimer() {
        guard let indexPath = collectionView.indexPathsForVisibleItems.last else {
            return
        }
        
        let next = IndexPath(item: (indexPath as NSIndexPath).row + 1, section: (indexPath as NSIndexPath).section)
        if (next as NSIndexPath).item == urls!.count * 200 {
            return
        }
        collectionView.scrollToItem(at: next, at: .left, animated: true)
    }
    
    // MARK: - 懒加载
    fileprivate lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ZXSLoopViewLayout())
    fileprivate lazy var pageView = UIPageControl()
}

extension ZXSLoopView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls!.count * (urls!.count == 1 ? 1 : 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kZXSLoopViewCellID, for: indexPath) as! ZXSLoopViewCell
        cell.imageUrl = urls![(indexPath as NSIndexPath).item % urls!.count]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard var offSet = (collectionView.indexPathsForVisibleItems.last as NSIndexPath?)?.item else {
            return
        }
        pageView.currentPage = offSet % self.urls!.count
        if offSet == 0 || offSet == (self.collectionView.numberOfItems(inSection: 0) - 1){
            offSet = self.urls!.count - (offSet == 0 ? 0 : 1)
            collectionView.contentOffset = CGPoint(x: CGFloat(offSet) * collectionView.bounds.width, y: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedBlock?((indexPath as NSIndexPath).row % urls!.count)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
}

