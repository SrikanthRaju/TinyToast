//
//  TinyToastEnum.swift
//  TinyToast
//
//  Created by keygx on 2017/08/09.
//  Copyright © 2017年 keygx. All rights reserved.
//

import Foundation

public enum TinyToastDisplayVAlign {
    case top
    case center
    case bottom
}

public enum TinyToastDisplayDuration {
    case short
    case normal
    case long
    case longLong
    
    func getDurationTime() -> DispatchTimeInterval {
        switch self {
            case .short: return .milliseconds(1500)
            case .normal: return .milliseconds(3000)
            case .long: return .milliseconds(5000)
            case .longLong: return .milliseconds(8000)
        }
    }
}

public enum TinyToastDisplayDirection {
    case up
    case left
    case right
    case down
}
