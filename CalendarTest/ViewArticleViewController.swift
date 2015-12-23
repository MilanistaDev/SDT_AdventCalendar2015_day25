//
//  ViewArticleViewController.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/22.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit

class ViewArticleViewController: UIViewController, UIWebViewDelegate {

    // カレンダー画面から記事のURL，タイトルを受け取る
    var articleLink: String?
    var articleNaviTitle: String?
    
    
    @IBOutlet var webView: UIWebView!
    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        
        self.navigationItem.title = articleNaviTitle!
        
        // 記事のURLからNSURLを生成
        let url = NSURL(string: self.articleLink!)
        
        // リクエスト生成
        let request: NSURLRequest = NSURLRequest(URL: url!)
        
        // リクエスト実行
        self.webView.loadRequest(request)
    }

    
    // UIWebViewDelegate method
    /**
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
    
    }
    */
    
    // MARK:- Memory warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
