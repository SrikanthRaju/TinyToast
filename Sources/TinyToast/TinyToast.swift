//
//  TinyToast.swift
//  TinyToast
//
//  Created by keygx on 2019/09/29.
//  Copyright © 2017年 keygx. All rights reserved.
//

import UIKit

public class TinyToast: TinyToastDelegate {
    // Singlton
    public static let shared = TinyToast()
    // Toast
    private let toastHandler = TinyToastHandler()
    // Queue List
    private var queue: [TinyToastModel] {
        didSet {
            if queue.count == 1 {
                next()
            }
        }
    }
    // Is Queued
    private var isQueued: Bool {
        if !queue.isEmpty {
            return true
        }
        return false
    }
    
    private init() {
        queue = [TinyToastModel]()
        toastHandler.delegate = self
    }
}

extension TinyToast {
    // Duration: Pre-Settings
    public func show(message: String,
                     valign: TinyToastDisplayVAlign = .center,
                     duration: TinyToastDisplayDuration,
                     backgoundColor: UIColor,
                     textColor: UIColor,
                     font: UIFont = UIFont.systemFont(ofSize: 15)) {
        AsyncUtil.sync {
            queue.append(TinyToastModel(message: message,
                                        valign: valign,
                                        duration: duration.getDurationTime(),
                                        backgoundColor: backgoundColor,
                                        textColor: textColor,
                                        font: font))
        }
    }
    
    // Duration: User Setting
    public func show(message: String,
                     valign: TinyToastDisplayVAlign = .center,
                     duration: TimeInterval,
                     backgoundColor: UIColor,
                     textColor: UIColor,
                     font: UIFont = UIFont.systemFont(ofSize: 15)) {
        AsyncUtil.sync {
            queue.append(TinyToastModel(message: message,
                                        valign: valign,
                                        duration: duration,
                                        backgoundColor: backgoundColor,
                                        textColor: textColor,
                                        font: font))
        }
    }
    
    public func dismiss() {
        if !isQueued {
            return
        }
        toastHandler.dismiss()
    }
    
    public func dismissAll() {
        if !isQueued {
            return
        }
        toastHandler.dismiss()
        AsyncUtil.sync {
            queue.removeAll()
        }
    }
}

extension TinyToast {
    private func next() {
        if !isQueued {
            return
        }
        toastHandler.show(message: queue[0].message,
                          valign: queue[0].valign,
                          duration: queue[0].duration,
                          backgoundColor: queue[0].backgoundColor,
                          textColor: queue[0].textColor,
                          font: queue[0].textFont)
    }
    
    func didCompleted() {
        if isQueued {
            AsyncUtil.sync {
                queue.removeFirst()
                next()
            }
        }
    }
}
