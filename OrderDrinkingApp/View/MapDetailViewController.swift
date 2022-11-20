//
//  MapDetailViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/11.
//

import UIKit
import MapKit
import CoreLocation     //使用得知位置函式庫

class MapDetailViewController: UIViewController, CLLocationManagerDelegate {
    var storeMapDeatilInfo: ChangeToStoreInfoDetail?
    
    var locationManger: CLLocationManager? //取得使用者位置使用變數

    @IBOutlet weak var mapDetailStoreNameLabel: UILabel!
    @IBOutlet weak var mapDetailStoreAddressLabel: UILabel!
    @IBOutlet weak var mapDetailView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lat = storeMapDeatilInfo?.lat ?? 0
        let lng = storeMapDeatilInfo?.lng ?? 0
        let detailStoreLocation = MKPointAnnotation()
        
        if let storeName = storeMapDeatilInfo?.storeName {
            mapDetailStoreNameLabel.text = storeName
            
            detailStoreLocation.title = "\(String(describing: storeName))"
        }
        detailStoreLocation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapDetailView.addAnnotation(detailStoreLocation)
        
        if let storeAddress = storeMapDeatilInfo?.storeAddress {
            mapDetailStoreAddressLabel.text = storeAddress
        }
        
        //定位
        locationManger = CLLocationManager() //指派locationManger取得CLLocationManager()功能
        locationManger?.requestWhenInUseAuthorization() //尋求使用者是否授權APP得知位置
        locationManger?.requestAlwaysAuthorization() //尋求使用者是否授權APP得知位置
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
            mapDetailView.setRegion(regineForNow, animated: true)
        }
        
        mapDetailView.userTrackingMode = .followWithHeading //追蹤模式為followWithHeading
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
