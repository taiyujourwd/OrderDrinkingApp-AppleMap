//
//  IndexViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/10.
//

import UIKit
import WebKit

class IndexViewController: UIViewController {

    var webView: WKWebView!

      override func loadView() {
          // 配置 WKWebView
          let webConfiguration = WKWebViewConfiguration()
          webView = WKWebView(frame: .zero, configuration:  webConfiguration)
          // 將我們的 view 指定為 webView
          view = webView
      }
    
      override func viewDidLoad() {
          super.viewDidLoad()
          // 讀取來自 URL 的網頁
          let myURL = URL(string:"https://www.chunshuitang.com.tw/")
          let myRequest = URLRequest(url: myURL!)
          webView.load(myRequest)
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
