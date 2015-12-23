//
//  CalendarViewController.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/14.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit
import Alamofire
import BXProgressHUD

class CalendarViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet var viewArticleButton: CustomDayButton!

    // インジケータ用
    var HUD:BXProgressHUD?
    
    let kAdventCalendarURLPrefix = "https://ajax.googleapis.com/ajax/services/feed/load?q=http://qiita.com/advent-calendar/2015/"
    let kAdventCalendarURLSuffix = "/feed&num=25&hl=ja&v=1.0"
    let kStoryboardName = "Main"
    let kNextStoryboardId = "PreviewVC"
    
    let kAuthorName = "authorName"
    let kArticleTitleName = "articleTitleName"
    let kAccessLinkURL = "accessLinkURL"
    
    // 取得したデータ格納用
    var feedDic: NSDictionary = [ : ]
    var articleDataArray: NSArray = []
    
    // 次の画面の渡すデータ用の NSDictionary
    var selectedArticleDataDic: NSDictionary = [ : ]
    
    // Top画面からカテゴリ名を受け取る(例：sdt)
    var keyword: String?
    // 12/1 の曜日用
    var weekDay: Int = 0
    // 12月が全部で何日あるか用
    var theNumOfDays: Int = 0
    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Qiita Advent Calendar 2015"
        self.viewArticleButton.enabled = false
        
        // StatusBar の色を白にする
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        

        // 12月で必要な計算実行
        self .dayCalc()
        
        // インジケータ開始
        self.HUD =  BXProgressHUD.Builder(forView: self.view).text("Loading") .create()
        self.HUD!.show()
        // 通信
        self .getFeedJSONData(keyword!)
    }

    // MARK:- Provate method
    // MARK: Network method

    /**
     * 通信してfeedのデータ(JSON)をArrayに入れる
     * 
     * @param keyword Top画面で入力したカテゴリ名
     */
    func getFeedJSONData(keyword:String) {
    
        // Top画面で入力したカテゴリ名を元にfeedを取得
        // feed を JSON で取得するために Google API を使用
        let feedURL = kAdventCalendarURLPrefix + keyword + kAdventCalendarURLSuffix
        
        // 通信処理
        Alamofire.request(.GET,feedURL).responseJSON { response in
            switch response.result {
            case .Success(let value):
                if let jsonDic = value as? NSDictionary {
                    
                    let statusCode = jsonDic["responseStatus"] as! NSInteger
                    if (statusCode == 400) {
                        self.HUD!.hide()
                        let weakSelf = self
                        weakSelf .showAlertAtReturnTop("Advent Calendar が存在しないようです")
                        return
                    }
                    if (statusCode != 200 && statusCode != 400) {
                        self.HUD!.hide()
                        let weakSelf = self
                        weakSelf .showAlertAtReturnTop("エラーです")
                        return
                    }
                    // Feed の JSON データが入る
                    let responseData = jsonDic["responseData"] as! NSDictionary
                    
                    // Advent Calendar の情報が入る
                    self.feedDic = responseData["feed"] as! NSDictionary
                    
                    // みんなのQiitaの記事の情報が入る
                    self.articleDataArray = self.feedDic["entries"] as! NSArray
                    
                    // 最新の記事から入るのでわかりやすいように古い方を最初に入れ替える
                    self.articleDataArray = self.articleDataArray.reverseObjectEnumerator().allObjects
                    
                    self.subTitleLabel.text = self.feedDic["title"] as? String
                    // インジケータ隠す
                    self.HUD!.hide()
                    BXProgressHUD.Builder(forView: self.view).mode(.Checkmark).text("Completed!!").show().hide(afterDelay: 2)
                }
            case .Failure(let error):
                // TODO:通信失敗時のエラーハンドリング
                print(error)
                self.HUD!.hide()
                let weakSelf = self
                weakSelf .showAlertAtReturnTop("ネットワークエラーのようです")
            }
        }
    }
    
    // MARK: Calendar method
    /**
     * カレンダー設定用
     * 月を変えればちゃんと表示されるように作ったつもり
     */
    func dayCalc() {
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        // Advent Calendar 用に日付指定
        let date = calendar.dateWithEra(1, year: 2015, month: 12, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!
        
        // Swift 2系から？
        let unitFlags: NSCalendarUnit = [ .Year,
                                          .Month,
                                          .Day,
                                          .Weekday,
                                          .Hour,
                                          .Minute,
                                          .Second ]
        
        // date(今回は12/1)が何曜か(weekdayは1から)
        let components = calendar.components(unitFlags, fromDate:date)
        weekDay = components.weekday
        
        // 指定月(今回は12月)は何日あるか
        let range : NSRange = calendar.rangeOfUnit(.Day, inUnit:.Month , forDate:date)
        theNumOfDays =  range.length;
    }
    
    // MARK: - IBAction
    
    @IBAction func viewArticle(sender: AnyObject) {
        
        let url = self.selectedArticleDataDic[kAccessLinkURL] as! String
        if ( url == "") {
            // アラート処理
            self .showNormalAlert("URLが存在しません・・・")
        } else {
            // 次の画面の StoryboardID を渡す
            self .passArticleLink(kNextStoryboardId)
        }
    }
    
    /**
    * キーワードを次の画面に渡すメソッド
    * @param next 遷移する Storyboard ID
    */
    func passArticleLink(url:String){
        let storyboard:UIStoryboard = UIStoryboard(name: kStoryboardName, bundle: nil)
        let receiveview:ViewArticleViewController = storyboard.instantiateViewControllerWithIdentifier(url) as! ViewArticleViewController
        // 次の画面にキーワードを値渡し
        receiveview.receivedArticleDataDic = self.selectedArticleDataDic
        self.navigationController?.pushViewController(receiveview, animated: true)
        //self.presentViewController(receiveview, animated: false, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegate method
    
    /// セル選択時の遷移処理
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        // indexPath.row を操作(カレンダー次第で変わる)
        let index : NSInteger = indexPath.row-weekDay+1
        
        // 記事がないところはエラーアラート表示
        if (index < 0 || index > self.articleDataArray.count-1) {
            self .showNormalAlert("記事がありません")
            return
        }
        
        // 該当記事データを抜き取る
        let authorName = (self.articleDataArray[index])["author"] as! String
        let articleTitleName = (self.articleDataArray[index])["title"] as! String
        let accessLinkURL = (self.articleDataArray[index])["link"] as! String

        // 次の画面に渡す用のデータDictionaryにデータを入れる
        self.selectedArticleDataDic = [kAuthorName : authorName,
                                       kArticleTitleName : articleTitleName,
                                       kAccessLinkURL : accessLinkURL]
        // 表示部分に表示
        self.authorNameLabel.text = self.selectedArticleDataDic[kAuthorName] as? String
        self.articleTitleLabel.text = self.selectedArticleDataDic[kArticleTitleName] as? String
        self.viewArticleButton.enabled = true
    }
    
    // MARK: - UICollectionViewDataSource Protocol
    
    /// セクション数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// セクションの中のセル数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDay-1+theNumOfDays;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // セル指定
        let cell:CalendarDayCell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell
        
        if (indexPath.row < weekDay-1) {
            cell.calendarDayLabel.text = ""
        } else {
            // セルの内容
            cell.calendarDayLabel.text = String(indexPath.row - weekDay+2)
            // 曜日によってセルのテキスト色変更
            if ((indexPath.row - weekDay+2)%7-1 == abs(weekDay-7)) {
                cell.calendarDayLabel.textColor = UIColor.blueColor()
            } else if ((indexPath.row - weekDay+2)%7-1+7 == abs(weekDay-7)) {
                cell.calendarDayLabel.textColor = UIColor.blueColor()
            } else if ((indexPath.row - weekDay+2)%7-2 == abs(weekDay-7)) {
                cell.calendarDayLabel.textColor = UIColor.redColor()
            } else if ((indexPath.row - weekDay+2)%7-2+7 == abs(weekDay-7)) {
                cell.calendarDayLabel.textColor = UIColor.redColor()
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout method
    
    /// セルのサイズ
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            // ステータスバーの高さを取得
            let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
            
            // ナビゲーションバーの高さを取得
            let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
            
            let barHeight = statusBarHeight + navigationBarHeight!
            
            // Util からでディスプレイサイズ取得
            // Width はそれを使い，高さは適切な値で返してやる
            let returnSize = CGSize(width: Util.returnDisplaySize().width/7, height: (self.collectionView.frame.size.height - barHeight-30)/5)
            
            return returnSize
    }
    
    // ヘッダーのサイズを設定
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            let size = CGSize(width: Util.returnDisplaySize().width, height: 30)
            return size
    }
    
    // MARK:- Alert
    
    /**
     * エラーアラート表示(通常)
     * 
     * @param msg エラーメッセージ
     */
    func showNormalAlert(msg: String) {
    
        let alertController = UIAlertController(title: "エラー", message: msg, preferredStyle: .Alert)
        let pushAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(pushAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     * エラーアラート表示(前の画面に戻す系)
     *
     * @param msg エラーメッセージ
     */
    func showAlertAtReturnTop(msg: String) {
        
        let alertController = UIAlertController(title: "エラー", message: msg, preferredStyle: .Alert)
        let otherAction = UIAlertAction(title: "前の画面に戻る", style: .Default) {
            action in self .backTop()
        }
        alertController.addAction(otherAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    /**
     * エラー時にカテゴリ入力画面に戻す
     *
     */
    func backTop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK:- Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

