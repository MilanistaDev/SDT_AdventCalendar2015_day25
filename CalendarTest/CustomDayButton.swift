//
//  CustomDayButton.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/16.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit

// リアルタイムで設定の変更が画面に反映
@IBDesignable

class CustomDayButton: UIButton {

    @IBInspectable var borderColor :  UIColor = UIColor.blackColor()
    @IBInspectable var borderWidth : CGFloat = 1.0
    @IBInspectable var cornerRadius : CGFloat = 5.0
    
    
    override func drawRect(rect: CGRect) {
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }

}
