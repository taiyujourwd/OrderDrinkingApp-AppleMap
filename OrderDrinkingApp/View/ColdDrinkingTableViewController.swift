//
//  ColdDrinkingTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/4.
//

import UIKit
import Kingfisher

class ColdDrinkingTableViewController: UITableViewController {
    
    //宣告空陣列儲存menu data
    var menuList = [DrinkingDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMenuList()
    }
    
    //下載Menu
    func loadMenuList() {
        let urlString = "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/DrinkingMenuList?api_key=keyyjw8cP0RNRL7GS"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data {
                    let decoder = JSONDecoder()
                    do {
                        let menuDataList = try decoder.decode(MenuList.self, from: data)
                        for i in 0...(menuDataList.records.count - 1){
                            if menuDataList.records[i].fields.iceHotKind[0] == "Ice" {
                                self.menuList.append(menuDataList.records[i].fields)
                            }
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
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ColdDrinkingTableViewCell.self)", for: indexPath) as! ColdDrinkingTableViewCell

        // Configure the cell...
        //冷飲放到cell裡
        cell.nameLabel.text = menuList[indexPath.row].name
        cell.priceLabel.text = "\(menuList[indexPath.row].price)"
        cell.priceLabel.clipsToBounds = true
        cell.priceLabel.layer.cornerRadius = 5
        cell.coldImageView.kf.setImage(with: menuList[indexPath.row].image[0].url)
        cell.coldImageView.clipsToBounds = true
        cell.coldImageView.layer.cornerRadius = 30
        return cell
    }
    
    
    @IBSegueAction func changeToOrderDrinking(_ coder: NSCoder) -> OrderDrinkingTableViewController? {
        
        let indexPath = tableView.indexPathForSelectedRow?.row
        
        let name = menuList[indexPath!].name
        let image = "\(menuList[indexPath!].image[0].url)"
        let price = menuList[indexPath!].price
        let iceHotKind = menuList[indexPath!].iceHotKind[0]
        let controller = OrderDrinkingTableViewController(coder: coder)
        controller?.drinkingInfo = ChangeToOrderDrinking(name: name, image: image, price: price, iceHotKind: iceHotKind)
        return controller
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
