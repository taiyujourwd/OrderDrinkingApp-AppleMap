//
//  MainViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/3.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageIndex: Int = 0
    
    // 在Assets存了七張圖片，儲存圖片的陣列
    let imageArray = ["1", "2", "3", "4", "5", "6", "7", "1"]
    
    @IBOutlet weak var photoCarouselCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var drinkingContainerViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 切換冷熱飲
        drinkingContainerViewsChange()
        
        //設定代理
        photoCarouselCollectionView.delegate = self
        photoCarouselCollectionView.dataSource = self
        
        //使用內建時間計數器每2秒換圖
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(autoPhotoCarousel), userInfo: nil, repeats: true)
        
        photoCarouselCollectionView.clipsToBounds = true
        photoCarouselCollectionView.layer.cornerRadius = 5
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        //切換冷熱飲
        drinkingContainerViewsChange()
        
    }
    
    //執行自動輪播
    @objc func autoPhotoCarousel() {
        var indexPath: IndexPath
        imageIndex += 1
        if imageIndex < imageArray.count {
            indexPath = IndexPath(item: imageIndex, section: 0)
            photoCarouselCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            //當圖片輪播到最後一張將imageIndex歸零，改以沒有動畫回到第一張
            imageIndex = 0
            indexPath = IndexPath(item: imageIndex, section: 0)
            photoCarouselCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            autoPhotoCarousel()
        }
    }
    
    //切換冷熱飲
    func drinkingContainerViewsChange() {
        drinkingContainerViews.forEach {
            $0.isHidden = true
        }
        drinkingContainerViews[segmentedControl.selectedSegmentIndex].isHidden = false
    }
    
    //回傳1個section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //回傳陣列中的圖片數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    //自定義重用cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotoCarouselCollectionViewCell.self)", for: indexPath) as! PhotoCarouselCollectionViewCell
        cell.photoCarouselImageView.image = UIImage(named: imageArray[indexPath.item])
        return cell
    }
    
    //取得collection view位置及大小資訊
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    //Collection View為左右捲動，所以cell左右間距為0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Collection View為左右捲動，所以cell上下間距為0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
