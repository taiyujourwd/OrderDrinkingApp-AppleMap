//
//  OrderListTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/6.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    var loadOrderInfoList = [LoadOrderInfoList.Records]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchOrderInfoList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchOrderInfoList()
    }
    
    func fetchOrderInfoList() {
        let url = URL(string: "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/OrderList?sort%5B0%5D%5Bfield%5D=createdTime&sort%5B0%5D%5Bdirection%5D=desc")!
        let apiKey = "Bearer keyyjw8cP0RNRL7GS"
        let httpHeader = "Authorization"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: httpHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let orderInfo = try decoder.decode(LoadOrderInfoList.self, from: data)
                    if orderInfo.records.count > 0 {
                        self.loadOrderInfoList = []
                        for i in 0...(orderInfo.records.count - 1){
                            self.loadOrderInfoList.append(orderInfo.records[i])
                        }
                        
                        let controller = UIAlertController(title: "使用通知", message: "點選訂單，可進入修改刪除頁面", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default)
                        controller.addAction(okAction)
                        self.present(controller, animated: true)
                    } else {
                        let controller = UIAlertController(title: "訊息通知", message: "目前尚無訂單", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "好的", style: .default)
                        controller.addAction(okAction)
                        self.present(controller, animated: true)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    @IBSegueAction func changeToUpdateOrderInfoSegue(_ coder: NSCoder) -> UpdateOrderTableViewController? {
        
        let indexPath = tableView.indexPathForSelectedRow?.row
        
        let id = loadOrderInfoList[indexPath!].id
        let userName = loadOrderInfoList[indexPath!].fields.userName
        let userPhone = loadOrderInfoList[indexPath!].fields.userPhone
        let drinkingName = loadOrderInfoList[indexPath!].fields.name
        let cupAmount = loadOrderInfoList[indexPath!].fields.cupAmount
        let iceDegree = loadOrderInfoList[indexPath!].fields.iceDegree
        let sugarDegree = loadOrderInfoList[indexPath!].fields.sugarDegree
        let comment = loadOrderInfoList[indexPath!].fields.comment
        let price = Int(loadOrderInfoList[indexPath!].fields.price)
        let storeName = loadOrderInfoList[indexPath!].fields.storeName
        
        let controller = UpdateOrderTableViewController(coder: coder)
        controller?.updateOrderInfo = ChangeToUpdateOrderInfo(id: id, userName: userName, userPhone: userPhone, drinkingName: drinkingName, cupAmount: cupAmount, iceDegreen: iceDegree, sugarDegreen: sugarDegree, comment: comment, price: price, storeName: storeName)
        return controller
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loadOrderInfoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as! OrderListTableViewCell
        
        cell.orderInfoUserNameLabel.text = loadOrderInfoList[indexPath.row].fields.userName
        cell.orderInfoUserPhoneLabel.text = loadOrderInfoList[indexPath.row].fields.userPhone
        cell.orderInfoDrinkingNameLabel.text = loadOrderInfoList[indexPath.row].fields.name
        cell.orderInfoCupAmountLabel.text = "\(loadOrderInfoList[indexPath.row].fields.cupAmount)"
        cell.orderInfoIceDegreeLabel.text = loadOrderInfoList[indexPath.row].fields.iceDegree
        cell.orderInfoSugarDegreeLabel.text = loadOrderInfoList[indexPath.row].fields.sugarDegree
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = dateFormatter.string(from: loadOrderInfoList[indexPath.row].createdTime)
        cell.orderInfoOrderTimeLabel.text = dateString
        
        cell.orderInfoCommentTextView.text = loadOrderInfoList[indexPath.row].fields.comment
        
        cell.orderInfoStoreNameLabel.text = loadOrderInfoList[indexPath.row].fields.storeName
        
        cell.orderInfoUserNameLabel.clipsToBounds = true
        cell.orderInfoUserNameLabel.layer.cornerRadius = 5
        cell.orderInfoUserPhoneLabel.clipsToBounds = true
        cell.orderInfoUserPhoneLabel.layer.cornerRadius = 5
        cell.orderInfoDrinkingNameLabel.clipsToBounds = true
        cell.orderInfoDrinkingNameLabel.layer.cornerRadius = 5
        cell.orderInfoCupAmountLabel.clipsToBounds = true
        cell.orderInfoCupAmountLabel.layer.cornerRadius = 5
        cell.orderInfoIceDegreeLabel.clipsToBounds = true
        cell.orderInfoIceDegreeLabel.layer.cornerRadius = 5
        cell.orderInfoSugarDegreeLabel.clipsToBounds = true
        cell.orderInfoSugarDegreeLabel.layer.cornerRadius = 5
        cell.orderInfoOrderTimeLabel.clipsToBounds = true
        cell.orderInfoOrderTimeLabel.layer.cornerRadius = 5
        cell.orderInfoCommentTextView.clipsToBounds = true
        cell.orderInfoCommentTextView.layer.cornerRadius = 5
        cell.orderInfoStoreNameLabel.clipsToBounds = true
        cell.orderInfoStoreNameLabel.layer.cornerRadius = 5
    
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! UpdateOrderTableViewController
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)") as! OrderListTableViewCell
        
        print(cell.orderInfoIceDegreeLabel.text!)
        nextController.updateOrderInfo?.iceDegreen = cell.orderInfoIceDegreeLabel.text!
    }
    */
}
