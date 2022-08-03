//
//  PredictStockVC.swift
//  Finance_App01
//
//  Created by Adel Al-Aali on 6/28/22.
//
// http://192.168.50.111:1110
// http://arobotsandbox.asuscomm.com:8501





import UIKit
import SwiftUI
import WebKit


class PredictWebSite {
    static var perform = PredictWebSite()
    static var site: String = "http://arobotsandbox.asuscomm.com:8501"
    func get() -> String {
        // return WebSite.site
        return "http://arobotsandbox.asuscomm.com:8501"
    }
    func change(symbol: String) -> String {
        PredictWebSite.site = "https://finance.yahoo.com/quote/\(symbol)?p=\(symbol)&.tsrc=fin-srch"
        return PredictWebSite.site
        // return "https://finance.yahoo.com/quote/\(symbol)?p=\(symbol)&.tsrc=fin-srch"
    }
    func changeByNotification(symbol: String, handler: ((String) -> Void)) {
        PredictWebSite.site = "https://finance.yahoo.com/quote/\(symbol)?p=\(symbol)&.tsrc=fin-srch"
        handler(PredictWebSite.site)
    }
}



class PredictStockVC : UIViewController, WKNavigationDelegate, WKUIDelegate {
    var homeTextValue: String? {
        didSet {
            print("[!] HomeTextValue Set --> WebViewController")
        }
    }
    
    private let backupURL : String = "http://192.168.50.111:1110"
    let dispatchGroup = DispatchGroup()

    func delayRun(after seconds: Int, completion: @escaping() -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) { completion() }
    }
    
    private var url : String?
    var urlStr : String?
    
    // TODO: Add this func to storyboard
    @IBAction func didTapHomeBtn() {
        print("[!] User Tapped Back Button ")
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func requestRfresh (_ sender: UIButton) {
        let searchURL = PredictWebSite.perform.get()
        let viewURL = URL(string: searchURL)
        print("[!] Sender Is Searching for webView-news \(String(describing: viewURL))")
        let backupURL = URL(string: backupURL)
        let request =  URLRequest(url: (viewURL ?? backupURL)!)
        webView!.load(request)
    }
    
    @IBOutlet weak var webView : WKWebView? {
        didSet {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            let webView = WKWebView(frame: .zero, configuration: configuration)
            parseUIView(webView)
        }
    }
    
    private func parseUIView(_ uiView: WKWebView) {
        let url = PredictWebSite.perform.get()
        let requestURL = URLRequest(url: URL(string: self.url ?? self.backupURL)!)
        print("[!] Starting Request on \(requestURL)")
        uiView.load(requestURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var viewURL = PredictWebSite.perform.get()
        var url = URL(string: viewURL)!
        let request =  URLRequest(url: url)
        webView!.load(request)
    }


}

public enum PredictStockVCErr : Error {
    case parsingUrlerr
}

extension PredictStockVCErr {
    public var webViewVCerrDescript : String {
        switch self {
        case .parsingUrlerr : return "[-] Error in parsing URL  "
        }
    }
}





/*

// TO PASS DATA TO NOTIFICATION CENTER
NotificationCenter.default
            .post(name: NSNotification.Name("com.user.login.success"),
             object: nil)
 
 let loginResponse = ["userInfo": ["userID": 6, "userName": "John"]]
 NotificationCenter.default
             .post(name: NSNotification.Name("com.user.login.success"),
              object: nil,
              userInfo: loginResponse)
 
 
 
*/


