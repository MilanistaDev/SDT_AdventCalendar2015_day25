//
//  ViewArticleViewController.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/22.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit
import BXProgressHUD
import Social

class ViewArticleViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    var myComposeView : SLComposeViewController!
    
    // カレンダー画面から記事のURL，タイトルを受け取る
    var receivedArticleDataDic: NSDictionary = [ : ]
    
    let kAuthorName = "authorName"
    let kArticleTitleName = "articleTitleName"
    let kAccessLinkURL = "accessLinkURL"
    
    // インジケータ用
    var HUD:BXProgressHUD?
    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
    
        // NavigationBar
        self.navigationItem.title = self.receivedArticleDataDic[kArticleTitleName] as? String
        let rightTweetBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action,
                                                                                   target: self,
                                                                                   action: "tweetButtonTapped")
        self.navigationItem.setRightBarButtonItems([rightTweetBarButtonItem], animated: true)
        
        // インジケータ生成
        self.HUD = BXProgressHUD.Builder(forView: self.view).text("Loading") .create()
        
        // 記事のURLからNSURLを生成
        let url = NSURL(string: (self.receivedArticleDataDic[kAccessLinkURL] as? String)! )
        
        // リクエスト生成
        let request: NSURLRequest = NSURLRequest(URL: url!)
        
        // リクエスト実行
        self.webView.loadRequest(request)
    }

    // MARK:- Provate method
    // Tweet 機能
    func tweetButtonTapped() {

        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿テキスト
        let tweetContentsText = (self.receivedArticleDataDic[kAuthorName] as? String)!+"\n"+(self.receivedArticleDataDic[kArticleTitleName] as? String)!+"\n"+(self.receivedArticleDataDic[kAccessLinkURL] as? String)!
        myComposeView.setInitialText(tweetContentsText)
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    
    // MARK:- UIWebViewDelegate method
    
    func webViewDidStartLoad(webView: UIWebView) {
    
        self.HUD!.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
    
        self.HUD!.hide()
    }
    
    // MARK:- Memory warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
