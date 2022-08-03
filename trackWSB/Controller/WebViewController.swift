//
//  WebViewViewController.swift
//  
//
//  Created by a-robota on 6/2/22.
//


import UIKit
import SwiftUI
import WebKit

// https://finance.yahoo.com/quote/AAPL?p=AAPL&.tsrc=fin-srch

class WebSite {
    static var perform = WebSite()
    static var site: String = "https://finance.yahoo.com/quote/AAPL?p=AAPL&.tsrc=fin-srch"
    func get() -> String {
        // return WebSite.site
        return "https://finance.yahoo.com/quote/AAPL?p=AAPL&.tsrc=fin-srch"
    }
    func change(symbol: String) -> String {
        WebSite.site = "https://finance.yahoo.com/quote/\(symbol)?p=\(symbol)&.tsrc=fin-srch"
        return WebSite.site
        // return "https://finance.yahoo.com/quote/\(symbol)?p=\(symbol)&.tsrc=fin-srch"
    }
    func changeByNotification(symbol: String, handler: ((String) -> Void)) {
        WebSite.site = "https://finance.yahoo.com/quote/\(symbol)?p=\(symbol)&.tsrc=fin-srch"
        handler(WebSite.site)
    }
}


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    
    
    var homeTextValue: String? {
        didSet {
            print("[!] HomeTextValue Set --> WebViewController")
        }
    }
    
    private let backupURL : String = "https://finance.yahoo.com/quote/AAPL?p=AAPL&.tsrc=fin-srch"
    let dispatchGroup = DispatchGroup()

    func delayRun(after seconds: Int, completion: @escaping() -> Void) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) { completion() }
    }
    
    private var url : String?
    var urlStr : String?
    var passedSearch00 : String?
    var passedSearch01 : String?
    
    // TODO: Add this func to storyboard
    @IBAction func didTapBackBtn() {
        print("[!] User Tapped Back Button ")
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
    
    @IBOutlet weak var textView : UITextField! {
        didSet{
            print("[!] Sender Is Searching for webView-news ")
            let symbol = textView.text?.uppercased()
            let backupURL = WebSite.perform.change(symbol: symbol!)
            print("[!] backupURL \(backupURL)")
            
        }
    }
    @IBAction func searchBtn (_ sender: UIButton) {
        let symbol = textView.text?.uppercased()
        let searchURL = WebSite.perform.change(symbol: symbol!)
        let viewURL = URL(string: searchURL)
        print("[!] Sender Is Searching for webView-news \(viewURL)")
        
        let backupURL = URL(string: backupURL)
        let request =  URLRequest(url: (viewURL ?? backupURL)!)
        webView!.load(request)
    }
    
    
    private func parseUIView(_ uiView: WKWebView) {
        let url = WebSite.perform.get()
        let requestURL = URLRequest(url: URL(string: self.url ?? self.backupURL)!)
        print("[!] Starting Request on \(requestURL)")
        uiView.load(requestURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var viewURL = WebSite.perform.get()
        var url = URL(string: viewURL)!
        let request =  URLRequest(url: url)
        parseNotification()
        webView!.load(request)
    }
    
    private func parseNotification() {
        let addSymbol2Url = NSNotification.Name.symbol.rawValue
        let url = URL(string: WebSite.perform.change(symbol: addSymbol2Url))!
        let request = URLRequest(url: url)
        webView!.load(request)
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

enum webViewVCerr: Error {
    case parsingUrlerr
}
extension webViewVCerr {
    public var webViewVCerrDescript : String {
        switch self {
        case .parsingUrlerr : return "[-] Error in parsing URL  "
        }
    }
}



