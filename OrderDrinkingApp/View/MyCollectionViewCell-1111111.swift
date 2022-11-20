//
//  MyCollectionViewCell.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/9.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
      func setupImageView(){
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 200)
        imageView.backgroundColor = .lightGray
        self.addSubview(imageView)
        }
    override func layoutSubviews() {
        setupImageView()
    }
}
