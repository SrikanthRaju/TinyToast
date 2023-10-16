//
//  AsyncUtil.swift
//  TinyToast
//
//  Created by keygx on 2017/08/10.
//  Copyright © 2017年 keygx. All rights reserved.
//

import Foundation

let serialQueue = DispatchQueue(label: "tinytoast.queue.serial", attributes: [])

final class AsyncUtil {
    class func onMainThread(_ block: @escaping () -> Void, delay: DispatchTimeInterval) {
        if delay.doubleValue == 0.0 {
            DispatchQueue.main.async {
                block()
            }
            return
        }
        
        let d = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: d) {
            block()
        }
    }
    
    class func sync(_ block: () -> Void) {
        serialQueue.sync {
            block()
        }
    }
}


extension DispatchTimeInterval {
    var doubleValue: Double {
        var result: Double = 0

        switch self {
            case .seconds(let value):
                result = Double(value)
            case .milliseconds(let value):
                result = Double(value)*0.001
            case .microseconds(let value):
                result = Double(value)*0.000001
            case .nanoseconds(let value):
                result = Double(value)*0.000000001

            case .never:
                result = 0
            @unknown default:
                result = 0
        }
        return result
    }
}
