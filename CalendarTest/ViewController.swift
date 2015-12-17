//
//  ViewController.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/14.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SDT Advent Calendar 2015"
        
        // StatusBar の色を白にする
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // CollectionView の設定
        self.collectionView.showsVerticalScrollIndicator = false
    }

    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // セル指定
        let cell:CalendarDayCell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarDayCell", forIndexPath: indexPath) as! CalendarDayCell
        
        // セルの内容
        cell.calendarDayLabel.text = String(indexPath.row + 1)
 
        return cell
    }
    
    /// セクション数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// セクションの中のセル数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31;
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
        let returnSize = CGSize(width: Util.returnDisplaySize().width/7, height: (self.collectionView.frame.size.height - barHeight)/5)
        
        return returnSize
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

