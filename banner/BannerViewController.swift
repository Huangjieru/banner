import UIKit

class BannerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var banners = ["1", "2", "3", "1"] // 假設橫幅圖片的名稱
    var currentIndex = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.delegate = self
//        collectionView.dataSource = self
        setupCollectionView()
        setupPageControl()
        startAutoScroll()
    }
    
    func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        
        // 將 Collection View 初始化位置設定到第一個物件之前的最後一個位置，以實現循環顯示
        let initialIndexPath = IndexPath(item: banners.count, section: 0)
        collectionView.scrollToItem(at: initialIndexPath, at: .left, animated: false)
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = banners.count - 1 // 除去最後一個物件
        pageControl.currentPage = 0
    }
    
    func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scrollToNextPage() {
        let nextIndex = (currentIndex + 1) % banners.count
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count * 3 // 重複顯示三次，以實現循環顯示
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath)
        
        let index = indexPath.item % banners.count
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.image = UIImage(named: banners[index])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        
        if contentOffsetX >= (2 * contentWidth) / 3 {
            // 滾動到最後一個物件之後，將 Collection View 位置設回第一個物件之前的最後一個位置
            let initialIndexPath = IndexPath(item: banners.count, section: 0)
            collectionView.scrollToItem(at: initialIndexPath, at: .left, animated: false)
        } else if contentOffsetX <= contentWidth / 3 {
            // 滾動到第一個物件之前，將 Collection View 位置設回最後一個物件之前的最後一個位置
            let initialIndexPath = IndexPath(item: banners.count * 2, section: 0)
            collectionView.scrollToItem(at: initialIndexPath, at: .left, animated: false)
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            let currentIndex = indexPath.item % banners.count
            pageControl.currentPage = currentIndex
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}
