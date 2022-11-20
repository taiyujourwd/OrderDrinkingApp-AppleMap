//
//  OrderListTableViewCell.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/6.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    var orderInfo: OrderInfo?
    
    @IBOutlet weak var orderInfoUserNameLabel: UILabel!
    @IBOutlet weak var orderInfoUserPhoneLabel: UILabel!
    @IBOutlet weak var orderInfoDrinkingNameLabel: UILabel!
    @IBOutlet weak var orderInfoCupAmountLabel: UILabel!
    @IBOutlet weak var orderInfoIceDegreeLabel: UILabel!
    @IBOutlet weak var orderInfoSugarDegreeLabel: UILabel!
    @IBOutlet weak var orderInfoOrderTimeLabel: UILabel!
    @IBOutlet weak var orderInfoCommentTextView: UITextView!
    @IBOutlet weak var orderInfoStoreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
