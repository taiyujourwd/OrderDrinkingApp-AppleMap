//
//  ColdDrinkingTableViewCell.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/4.
//

import UIKit

class ColdDrinkingTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var coldImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
