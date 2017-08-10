//
//  TTModel.swift
//  TinyToast
//
//  Created by keygx on 2017/08/10.
//  Copyright © 2017年 keygx. All rights reserved.
//

import Foundation

struct TTModel {
    var message: String
    var valign: TinyToastDisplayVAlign
    var duration: TinyToastDisplayDuration
    
    init(message: String, valign: TinyToastDisplayVAlign, duration: TinyToastDisplayDuration) {
        self.message = message
        self.valign = valign
        self.duration = duration
    }
}
