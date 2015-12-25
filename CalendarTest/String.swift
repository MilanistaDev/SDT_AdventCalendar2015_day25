//
//  String.swift
//  CalendarTest
//
//  Created by 麻生 拓弥 on 2015/12/25.
//  Copyright © 2015年 麻生 拓弥. All rights reserved.
//

import UIKit

extension String {
    
    func getTextSize(font:UIFont, viewWidth:CGFloat, padding:CGFloat) -> CGSize {
        var size = CGSizeZero
        
        if let s:CGSize = self.makeSize(viewWidth, font: font) {
            size = CGSize(width: s.width, height: s.height + padding)
        }
        return size
    }
    
    func makeSize(width:CGFloat, font:UIFont) -> CGSize {
        var size:CGSize = CGSizeZero
        
        if self.respondsToSelector("boundingRectWithSize:options:attributes:context:") {
            let bounds:CGSize = CGSize(width: width, height: CGFloat.max)
            let attributes: Dictionary = [NSFontAttributeName: font]
            let options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue |
                NSStringDrawingOptions.UsesFontLeading.rawValue, NSStringDrawingOptions.self)
            
            let rect:CGRect = self.boundingRectWithSize(bounds, options: options, attributes: attributes, context: nil)
            size = CGSize(width: rect.size.width, height: rect.size.height)
        }
        return size
    }
}
