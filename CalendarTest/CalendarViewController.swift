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

class CalendarViewController: UIViewController,UICollectionViewDelegate {

    @IBOutlet var calendarTitleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var subTitleLabel: UILabel!
    
    let kAdventCalendarURLPrefix = "https://ajax.googleapis.com/ajax/services/feed/load?q=http://qiita.com/advent-calendar/2015/"
    let kAdventCalendarURLSuffix = "/feed&num=25&hl=ja&v=1.0"
    var articleDataArray :NSArray = []
    
    // Top画面からカテゴリ名を受け取る(例：sdt)
    var keyword: String?
    // 12/1 の曜日
    var weekDay: Int = 0
    // 12月が全部で何日あるか
    var theNumOfDays: Int = 0
    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Advent Calendar 2015"

        
        // 12月で必要な計算実行
        self .dayCalc()
        
        // StatusBar の色を白にする
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // CollectionView の設定(でないはず)
        self.collectionView.showsVerticalScrollIndicator = false
        
        // 通信
        self .getFeedJSONData(keyword!)
    }

    // MARK:- Provate method
    
    func getFeedJSONData(keyword:String) {
    
        let feedURL = kAdventCalendarURLPrefix + keyword + kAdventCalendarURLSuffix
        
        
        Alamofire.request(.GET,feedURL).responseJSON { response in
            switch response.result {
            case .Success(let value):
                if let jsonDic = value as? NSDictionary {
                    let responseData = jsonDic["responseData"] as! NSDictionary
                    let feed = responseData["feed"] as! NSDictionary
                    self.articleDataArray = feed["entries"] as! NSArray
                    let calendarTitle = feed["title"] as! String
                    print((self.articleDataArray[0])["author"] as! String)

                    self.calendarTitleLabel.text = calendarTitle
                    self.articleDataArray = self.articleDataArray.reverseObjectEnumerator().allObjects
                }
            case .Failure(let error):
                // 通信のエラーハンドリングしたいなら
                print(error)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func dayCalc() {
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        // NSDate() でもいいけど訳あり・・・
        let date = calendar.dateWithEra(1, year: 2015, month: 12, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!
        
        // Swift 2系から？
        let unitFlags: NSCalendarUnit = [ .Year,
            .Month,
            .Day,
            .Weekday,
            .Hour,
            .Minute,
            .Second ]
        
        // セクション用
        let year = calendar.component(.Year, fromDate: date)
        let month = calendar.component(.Month, fromDate: date)
        self.subTitleLabel.text = String(year) + "年" + String(month) + "月_" + keyword!
        
        // dateが何曜か(weekdayは1から)
        let components = calendar.components(unitFlags, fromDate:date)
        weekDay = components.weekday
        
        // 指定月は何日あるか
        let range : NSRange = calendar.rangeOfUnit(.Day, inUnit:.Month , forDate:date)
        theNumOfDays =  range.length;
        
    }
    
    // MARK: - UICollectionViewDelegate Protocol
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
    
    /// セクション数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// セクションの中のセル数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDay-1+theNumOfDays;
    }
    
    /// セルのサイズ
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
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
        
    /// セル選択時の遷移処理
    /**
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 次の画面のStoryboardIDを渡す
        self .passKeyword("ListVC")
    }
*/
    
    /**
     * キーワードを次の画面に渡すメソッド
     * @param next 次の Storyboard ID
     */
    /**
    func passKeyword(next:String){
        let storyboard:UIStoryboard = UIStoryboard(name: "List", bundle: nil)
        let receiveview:ListViewController = storyboard.instantiateViewControllerWithIdentifier(next) as! ListViewController
        // 次の画面にキーワードを値渡し
        receiveview.keyword = self.textBox.text
        self.navigationController?.pushViewController(receiveview, animated: true)
        //self.presentViewController(receiveview, animated: false, completion: nil)
    }
    */
    
    // MARK:- Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

