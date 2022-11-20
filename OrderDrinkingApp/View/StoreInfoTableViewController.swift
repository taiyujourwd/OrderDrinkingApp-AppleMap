//
//  StoreInfoTableViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/10.
//

import UIKit
import MapKit
import CoreLocation     //使用得知位置函式庫

class StoreInfoTableViewController: UITableViewController, CLLocationManagerDelegate {
    var storeInfo = [StoreInfo.StoreDetail]()
    var locationManger: CLLocationManager? //取得使用者位置使用變數
    var lat: Double = 0
    var lng: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchStoreInfo(lat, lng)
    }
        
    func fetchUserLocation() {
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
        }
    }
    
    func fetchStoreInfo(_ lat: Double, _ lng: Double) {
//        fetchUserLocation()
        
        let orgUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=1000&keyword=春水堂&language=zh-TW&key=AIzaSyDK7dj5GZheIWk_HSbF7Gv7AakP0Vvxro8"
        //網址有中文字，需進行編碼
        let strUrl = orgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let request = URLRequest(url: URL(string: strUrl!)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let storeInfoDecode = try decoder.decode(StoreInfo.self, from: data)
                    self.storeInfo = []
                    if storeInfoDecode.results.count != 0 {
                        for i in 0...(storeInfoDecode.results.count - 1){
                            self.storeInfo.append(storeInfoDecode.results[i])
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        if self.storeInfo.count == 0 {
                            let controller = UIAlertController(title: "店家訊息通知", message: "您所在附近沒有店家", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "好的", style: .default)
                            controller.addAction(okAction)
                            self.present(controller, animated: true)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    @IBSegueAction func changeToStoreInfoDeailSegue(_ coder: NSCoder) -> MapDetailViewController? {
        
        let indexPath = tableView.indexPathForSelectedRow?.row
        
        let storeName = storeInfo[indexPath!].name
        let storeAddress = storeInfo[indexPath!].vicinity
        let lat = Double(storeInfo[indexPath!].geometry.location.lat)
        let lng = Double(storeInfo[indexPath!].geometry.location.lng)
        
        let controller = MapDetailViewController(coder: coder)
        controller?.storeMapDeatilInfo = ChangeToStoreInfoDetail(storeName: storeName, storeAddress: storeAddress, lat: lat, lng: lng)
        return controller
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StoreInfoTableViewCell.self)", for: indexPath) as! StoreInfoTableViewCell
        
        // Configure the cell...
        cell.storeNameLabel.text = storeInfo[indexPath.row].name
        cell.storeAddressLabel.text = storeInfo[indexPath.row].vicinity
        
        //每一個Cell顯示地圖，以每家店為中心顯示地圖
        let location = CLLocation(latitude: storeInfo[indexPath.row].geometry.location.lat, longitude: storeInfo[indexPath.row].geometry.location.lng)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        cell.mapView.setRegion(region, animated: true)
        
        let storeLocation = MKPointAnnotation()
        storeLocation.title = "\(storeInfo[indexPath.row].name)"
        storeLocation.coordinate = CLLocationCoordinate2D(latitude: storeInfo[indexPath.row].geometry.location.lat, longitude: storeInfo[indexPath.row].geometry.location.lng)
        cell.mapView.addAnnotation(storeLocation)
        
        cell.mapView.clipsToBounds = true
        cell.mapView.layer.cornerRadius = 5
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
