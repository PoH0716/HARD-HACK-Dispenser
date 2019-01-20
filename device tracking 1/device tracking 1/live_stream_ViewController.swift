//
//  live_stream_ViewController.swift
//  device tracking 1
//
//  Created by Saikiran Komatineni on 1/20/19.
//  Copyright © 2019 saikiran. All rights reserved.
//

import UIKit
import WebKit

class live_stream_ViewController: UIViewController, WKNavigationDelegate {

    //@IBOutlet weak var webViewLive: WKWebView!
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            print("Prog ",webViewLive.estimatedProgress)
//        }
//    }
    var webView: WKWebView!
    let reloadButton = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 50))
    
    @objc func touchDown() {
        webView.reload()
    }
    
    @objc func touchUp() {
        
    }
    
    override func loadView() {
        reloadButton.setTitle("Reload", for: .normal)
        //reloadButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: reloadButton.frame.height * 0.4)
        reloadButton.backgroundColor = UIColor.red
        reloadButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
        reloadButton.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        webView = WKWebView()
        webView.navigationDelegate = self
        //webView.bounds.height = UIScreen.main.bounds.height * 0.7
        view = webView
        self.view.insertSubview(reloadButton, aboveSubview: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let url = URL(fileURLWithPath: "https://100.80.245.27:8081")
        let url = URL(string: "http://100.80.245.27:8081")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.becomeFirstResponder()
        // Do any additional setup after loading the view.
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
