//
//  TinyToastModel.swift
//  TinyToast
//
//  Created by keygx on 2017/08/10.
//  Copyright © 2017年 keygx. All rights reserved.
//

import Foundation
import UIKit.UIColor
import UIKit.UIFont


struct TinyToastModel {
    var message: String
    var valign: TinyToastDisplayVAlign
    var duration: DispatchTimeInterval
    var backgoundColor: UIColor
    var textColor: UIColor
    var textFont: UIFont

    init(message: String, valign: TinyToastDisplayVAlign, duration: DispatchTimeInterval, backgoundColor: UIColor, textColor: UIColor, font: UIFont) {
        self.message = message
        self.valign = valign
        self.duration = duration
        self.backgoundColor = backgoundColor
        self.textColor = textColor
        self.textFont = font
    }
}
