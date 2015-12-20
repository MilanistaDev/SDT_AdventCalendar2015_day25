//
//  TopViewController.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/19.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var keywordTextFeild: UITextField!

    let kInputKeyword = "キーワードを入力"
    let kStoryboardName = "Main"
    let kNextStoryboardId = "CalendarVC"
    let kDescription = "見たい Advent Calendar 2015 のカテゴリ名を入力"
    let kPlaceholderExample = "http://...calendar/2015/sdt <-これ"
    
    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = kInputKeyword
        self.descriptionLabel.text = kDescription
        
        // テキストフィールドの初期設定
        self.keywordTextFeild.delegate = self
        self.keywordTextFeild.text = ""
        self.keywordTextFeild.placeholder = kPlaceholderExample
    }
    
    // MARK:- IBAction
    
    @IBAction func sendKeywordButton(sender: AnyObject) {
        
        if (self.keywordTextFeild.text == "") {
            // TODO: アラート処理
        } else {
            // 次の画面の StoryboardID を渡す
            self .passKeyword(kNextStoryboardId)
        }
    }
    
    // MARK:- Private method
    
    /**
     * キーワードを次の画面に渡すメソッド
     * @param next 遷移する Storyboard ID
     */
    func passKeyword(next:String){
        let storyboard:UIStoryboard = UIStoryboard(name: kStoryboardName, bundle: nil)
        let receiveview:CalendarViewController = storyboard.instantiateViewControllerWithIdentifier(next) as! CalendarViewController
        // 次の画面にキーワードを値渡し
        receiveview.keyword = self.keywordTextFeild.text
        self.navigationController?.pushViewController(receiveview, animated: true)
        //self.presentViewController(receiveview, animated: false, completion: nil)
    }
    
    
    //MARK: - UITextField Delegate Method
    func textFieldShouldReturn(keywordTextFeild: UITextField) -> Bool {
        
        // キーボードを閉じる
        keywordTextFeild.resignFirstResponder()
        
        return true
    }
    
    // MARK:- Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
