//
//  OrderDrinkingTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/5.
//

import UIKit
import Kingfisher
import MapKit
import CoreLocation     //使用得知位置函式庫


class OrderDrinkingTableViewController: UITableViewController, CLLocationManagerDelegate {
    var drinkingInfo: ChangeToOrderDrinking?
    var storeInfo = [StoreInfo.StoreDetail]()
    var locationManger: CLLocationManager? //取得使用者位置使用變數
    var lat: Double = 0
    var lng: Double = 0
    var location = [String]()
    var locationPickerView = UIPickerView()
    
    @IBOutlet weak var orderDrinkingIceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderDrinkingNameLabel: UILabel!
    @IBOutlet weak var orderDrinkingImageView: UIImageView!
    @IBOutlet weak var orderDrinkingPriceLabel: UILabel!
    @IBOutlet weak var orderDrinkingSugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderDringkingCupTextField: UITextField!
    @IBOutlet weak var orderDrinkingCommentTextView: UITextView!
    @IBOutlet weak var orderDrinkingUserNmanTextField: UITextField!
    @IBOutlet weak var orderDrinkingUserPhoneTextField: UITextField!
    @IBOutlet weak var orderDrinkingStoreNameTextField: UITextField!
    
    
    
    var name: String = ""
    var price: Int = 0
    var iceDegree: String = ""
    var sugarDegree: String = ""
    var cupAmount: Int = 0
    var comment: String = ""
    var userName: String = ""
    var userPhone: String = ""
    var totalAmount: Int = 0
    var storeName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        locationPickerView.dataSource = self
        locationPickerView.delegate = self
        
        orderDrinkingStoreNameTextField.inputView = locationPickerView
        
        orderDringkingCupTextField.isEnabled = false
        
        //設定要訂購的飲料資訊,前頁傳過來的值
        if let drinkingName = drinkingInfo?.name, let drinkingPrice = drinkingInfo?.price, let drinkImage = drinkingInfo?.image, let iceHotKind = drinkingInfo?.iceHotKind {
                        
            if iceHotKind == "Hot" {
                orderDrinkingIceSegmentedControl.isEnabled = false
                orderDrinkingPriceLabel.backgroundColor = UIColor.orange
            }
            
            orderDrinkingNameLabel.text = drinkingName
            orderDrinkingImageView.kf.setImage(with: URL(string: drinkImage))
            orderDrinkingPriceLabel.text = "\(drinkingPrice)"
        }
        
        orderDrinkingPriceLabel.clipsToBounds = true
        orderDrinkingPriceLabel.layer.cornerRadius = 5
        orderDrinkingCommentTextView.clipsToBounds = true
        orderDrinkingCommentTextView.layer.cornerRadius = 5
        
        //定位
        locationManger = CLLocationManager() //指派locationManger取得CLLocationManager()功能
        locationManger?.requestWhenInUseAuthorization() //尋求使用者是否授權APP得知位置
        locationManger?.delegate = self //若是user有移動，可以將透過delegate知道位置顯示
        locationManger?.desiredAccuracy = kCLLocationAccuracyBest //user位置追蹤精確程度，設置成最精確位置
        locationManger?.activityType = .automotiveNavigation //設定使用者的位置模式，手機會去依照不同設定做不同的電力控制
        locationManger?.startUpdatingLocation() //user有移動會啟動追蹤位置(CLLocationManagerDelegate)
            
        //授權同意後取得使用者位置後指派給hereForNow
        if let hereForNow = locationManger?.location?.coordinate {
            let scaleForX: CLLocationDegrees = 0.01 //精度緯度設置為0.01
            let scaleForY: CLLocationDegrees = 0.01
            
            //指派span為MKCoordinateSpan後加入精度緯度的比例
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: scaleForY, longitudeDelta: scaleForX)
            //指派regineForNow為MKCoordinateRegion加入現在的user位置，顯示比例為span
            let regineForNow = MKCoordinateRegion(center: hereForNow, span: span)
            lat = regineForNow.center.latitude
            lng = regineForNow.center.longitude
            
            fetchStoreInfo(lat, lng)
//            fetchStoreInfo(24.137459053030295, 120.68694266895422)
            
            //延遲1秒讓店家資料loading completed存到storeInfo
            Thread.sleep(forTimeInterval: 1)
            
            if storeInfo.count > 0 {
                self.location.append("")
                for i in 0...(storeInfo.count - 1) {
                    location.append(storeInfo[i].name)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.storeInfo.count == 0 {
            let controller = UIAlertController(title: "店家訊息通知", message: "您所在附近沒有店家", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default)
            controller.addAction(okAction)
            self.present(controller, animated: true)
        }
    }
    
    //碰觸其他地方Picker隱藏
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func orderDrinkingCupStepper(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        orderDringkingCupTextField.text = String(stepperValue)
    }
    
    @IBAction func orderDrinkingOrderButtonAction(_ sender: Any) {
        let iceHotKind = drinkingInfo?.iceHotKind
        let ice: Int = orderDrinkingIceSegmentedControl.selectedSegmentIndex
        let sugar: Int = orderDrinkingSugarSegmentedControl.selectedSegmentIndex
        
        self.name = orderDrinkingNameLabel.text!
        self.price = Int(orderDrinkingPriceLabel.text!)!
        self.iceDegree = "\(iceHotKind == "Ice" ? (ice == 0 ? "正常" : ice == 1 ? "8分冰" : "去冰") : "熱飲")"
        self.sugarDegree = "\(sugar == 0 ? "正常" : sugar == 1 ? "8分糖" : sugar == 2 ? "5分糖" : sugar == 3 ? "3分糖" : "無糖")"
        if let cupAmount = orderDringkingCupTextField.text {
            self.cupAmount = Int(cupAmount) ?? 0
        }
        if let comment = orderDrinkingCommentTextView.text {
            self.comment = comment
        }
        self.userName = orderDrinkingUserNmanTextField.text!
        self.userPhone = orderDrinkingUserPhoneTextField.text!
        self.totalAmount = self.price * self.cupAmount
        self.storeName = orderDrinkingStoreNameTextField.text!
        
        if userName.isEmpty == true || userPhone.isEmpty == true || storeName.isEmpty == true {
            let controller = UIAlertController(title: "欄位空白", message: "請輸入訂購店家、姓名及電話", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default)
            controller.addAction(okAction)
            present(controller, animated: true)
        }
        
        //確認訂單
        let controller = UIAlertController(title: "訂單確認", message: "總共 \(self.cupAmount) 杯\n 總金額:\(self.totalAmount)\n請問是否訂購?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            self.uploadOrderInfo(name: self.name, price: self.price, iceDegree: self.iceDegree, sugarDegree: self.sugarDegree, cupAmount: self.cupAmount, comment: self.comment, userName: self.userName, userPhone: self.userPhone, totalAmount: self.totalAmount, storeName: self.storeName)
        }
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    //上傳訂單資訊
    func uploadOrderInfo(name: String, price: Int, iceDegree: String, sugarDegree: String, cupAmount: Int, comment: String, userName: String, userPhone: String, totalAmount: Int, storeName: String) {
        
        //計算總金額
        self.totalAmount = price * cupAmount
        
        let url = URL(string: "https://api.airtable.com/v0/appHy2q9FOUrGGhqS/OrderList")!
        let apiKey = "Bearer keyyjw8cP0RNRL7GS"
        let httpHeader = "Authorization"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: httpHeader)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let fieldsData = UploadOrderData.Fields(name: name, price: price, iceDegree: iceDegree, sugarDegree: sugarDegree, cupAmount: cupAmount, comment: comment, userName: userName, userPhone: userPhone, totalAmount: totalAmount, storeName: storeName)
        let uploadData = UploadOrderData.Records(fields: fieldsData)
        let data = try? encoder.encode(uploadData)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let _ = try decoder.decode(OrderInfo.self, from: data)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        let controller = UIAlertController(title: "訂購通知", message: "己完成訂購", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default)
        controller.addAction(okAction)
        self.present(controller, animated: true)
    }
    
    //取得店家資訊
    func fetchStoreInfo(_ lat: Double, _ lng: Double) {
        let orgUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=1000&keyword=春水堂&language=zh-TW&key=AIzaSyDK7dj5GZheIWk_HSbF7Gv7AakP0Vvxro8"
        //網址有中文字，需進行編碼
        let strUrl = orgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let request = URLRequest(url: URL(string: strUrl!)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let storeInfoDecode = try decoder.decode(StoreInfo.self, from: data)
                    if storeInfoDecode.results.count != 0 {
                        for i in 0...(storeInfoDecode.results.count - 1){
                            self.storeInfo.append(storeInfoDecode.results[i])
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
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

extension OrderDrinkingTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return location.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return location[row]
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        orderDrinkingStoreNameTextField.text = location[row]
    }
    
}
