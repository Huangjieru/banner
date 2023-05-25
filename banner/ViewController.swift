//
//  ViewController.swift
//  banner
//
//  Created by jr on 2023/5/23.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var time:Timer?
    //紀錄目前banner播放到第幾個cell
    var imageIndex = 0
    var banners = ["1","2","3","1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        configureCellSize()
        
        pageControl.numberOfPages = banners.count - 1
        pageControl.backgroundStyle = .prominent
        
        //每兩秒輪播下一個圖片
        time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
        
    }
    
    func configureCellSize(){
        if let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
            
        }
    }
    
    @objc func changeBanner(){
        
        var indexPath:IndexPath
        
        //imageIndex加一轉動圖片到下一張
        imageIndex += 1
        //沒有在陣列裡自行新增最後一筆資料，圖片跑到最後會被硬拉回第一張
//        if imageIndex == banners.count{
//            imageIndex = 0
//        }
        //在banner陣列裡再加入第一筆圖片名稱，當不是最後一筆資料時
        if imageIndex < banners.count{

            //用imageIndex去產生一個indexPath
            indexPath = IndexPath(item: imageIndex, section: 0)
            //讓collectionView去選indexPath
            bannerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            pageControl.currentPage = imageIndex
            //當imageIndex是banner陣列裡的最後一筆資料時，將page control設為0，也就是第一張圖
            if imageIndex == banners.count - 1{
                pageControl.currentPage = 0
            }
            print("imageIndex:\(imageIndex)")
        }else
        {
            //當banner數量等於banner陣列的最後一筆資料，回到第一筆資料
            imageIndex = 0
            pageControl.currentPage = 0
            indexPath = IndexPath(item: imageIndex, section: 0)
            //不要動畫先回到第一張圖
            bannerCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            print("imageIndex 4:\(imageIndex)")
            //再重新輪播
            changeBanner()
        }
        
    }
    
    
    //MARK: - Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        let indexPath = banners[indexPath.item]
        cell.bannerImageView.contentMode = .scaleAspectFill
        cell.bannerImageView.image = UIImage(named: "\(indexPath)")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bannerCollectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = ceil(scrollView.contentOffset.x /  scrollView.bounds.size.width)
        pageControl.currentPage = Int(currentPage)
//        pageControl.backgroundStyle = .prominent
//        pageControl.numberOfPages = banners.count
//        for page in 0..<banners.count{
//            pageControl.setIndicatorImage(UIImage(systemName: "\(page+1).circle"), forPage: page)
//        }
        
    }*/
}

