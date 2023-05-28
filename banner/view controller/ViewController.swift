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
    var photos = [PhotoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        configureCellSize()
        bannerCollectionView.backgroundColor = .systemGray6
        PhotoRequest().sendRequest { result in
            print("抓資料結果：\(result)")
            switch result{
            case .success(let photos):
                    self.photos = photos
                    self.photos.append(photos[0])
                print("圖片數量：\(self.photos.count)")
                DispatchQueue.main.async {
                    self.pageControl.numberOfPages = self.photos.count - 1
                    self.pageControl.backgroundStyle = .prominent
                    self.bannerCollectionView.reloadData()
                }
                print("回傳的資料：\(photos)")
            case .failure:
                break
            }
        }
 
        //每兩秒輪播下一個圖片
        time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    //collection view cell滑動方向
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
        if imageIndex < photos.count{

            //用imageIndex去產生一個indexPath
            indexPath = IndexPath(item: imageIndex, section: 0)
            //讓collectionView去選indexPath
            bannerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            pageControl.currentPage = imageIndex
            //當imageIndex是banner陣列裡的最後一筆資料時，將page control設為0，也就是第一張圖
            if imageIndex == photos.count - 1{
                pageControl.currentPage = 0
            }
//            print("imageIndex:\(imageIndex)")
        }else
        {
            //當banner數量等於banner陣列的最後一筆資料，回到第一筆資料
            imageIndex = 0
            pageControl.currentPage = 0
            indexPath = IndexPath(item: imageIndex, section: 0)
            //不要動畫先回到第一張圖
            bannerCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
//            print("imageIndex 4:\(imageIndex)")
            //再重新輪播
            changeBanner()
        }
        
    }
    
    
    //MARK: - Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bannerCollectionViewcell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.reuseIdentifier, for: indexPath) as! BannerCollectionViewCell
        let indexPath = photos[indexPath.item]
        bannerCollectionViewcell.cellConfigurate(cell: bannerCollectionViewcell)
        fetchImage(from: indexPath.urls.regular) { image in
                DispatchQueue.main.async {
                    bannerCollectionViewcell.bannerImageView.image = image
                }
            }

            return bannerCollectionViewcell
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
    //抓取圖片
    func fetchImage(from url: URL, completion: @escaping (UIImage?)->Void){
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error{
                    completion(nil)
                }else if let data = data, let image = UIImage(data: data){
                    completion(image)
                }else{
                    completion(nil)
                }
            }.resume()
        }
}

