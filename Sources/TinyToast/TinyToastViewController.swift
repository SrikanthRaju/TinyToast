//
//  TinyToastViewController.swift
//  TinyToast
//
//  Created by keygx on 2019/09/29.
//  Copyright © 2019 keygx. All rights reserved.
//

import UIKit

final class TinyToastViewController: UIViewController {
    var message: String = ""
    var valign: TinyToastDisplayVAlign = .center
    var textColor: UIColor = UIColor.white
    var backgroundColor: UIColor = UIColor.black
    var textFont: UIFont = UIFont.systemFont(ofSize: 15)

    private var toastView: UIView?
    private var textLabel: UILabel?
    private let windowWidthRatio: CGFloat = 0.9 // 95% of parent screen width
    private var fontSize: CGFloat {
        textFont.fontDescriptor.pointSize
    }
    private let margin: CGFloat = 40.0
    // Size of ToastView
    private var toastViewRect: CGRect {
        return CGRect(x: 0,
                      y: 0,
                      width: UIScreen.main.bounds.width * windowWidthRatio,
                      height: UIScreen.main.bounds.height)
    }
    // Charactors counts of 1 line
    private var oneLineLength: CGFloat {
        return floor(toastViewRect.width * windowWidthRatio / fontSize)
    }
    // Label Width
    private var labelWidth: CGFloat {
        return oneLineLength * fontSize
    }
    
    // Direction of Statusbar
    static var orientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        switch TinyToastViewController.orientation {
        case .landscapeLeft, .landscapeRight:
            // LandscapeLeft | LandscapeRight
            return true
        default:
            // Unknown | Portrait | PortraitUpsideDown
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = false
        
        // Create Label
        let messageLabel = createMessageLabel(message: message)
        messageLabel.textColor = self.textColor
        messageLabel.tag = 10502
        // Create Toast
        toastView = createToastView(messageLabelWidth: messageLabel.bounds.width,
                                    messageLabelHeight: messageLabel.bounds.height)
        toastView?.backgroundColor = backgroundColor
        toastView?.layer.borderWidth = 0.5
        toastView?.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        toastView?.layer.shadowColor = backgroundColor.withAlphaComponent(0.4).cgColor
        toastView?.layer.shadowOpacity = 0.4
        toastView?.layer.shadowRadius = 6
        
        toastView?.addSubview(messageLabel)
    }
    
    override func viewWillLayoutSubviews() {
        guard let toastView = toastView, let textLabel = toastView.viewWithTag(10502) as? UILabel else { return }
        
        // Rotate Toast View
        let angle = getAngle(orientation: TinyToastViewController.orientation)
        toastView.transform = CGAffineTransform(rotationAngle: angle.0)
        view.addSubview(toastView)
        
        // Centering
        toastView.center = view.center
        
        // Toast View Position
        switch valign {
        case .top:
            switch angle.1 {
            case .up:
                toastView.frame.origin.y =
                    margin + getExtraMargin(orientation: .up, valign: .top)
            case .left:
                toastView.frame.origin.x =
                    margin + getExtraMargin(orientation: .left, valign: .top)
            case .right:
                toastView.frame.origin.x =
                    view.frame.width - toastView.frame.width
                    - margin - getExtraMargin(orientation: .right, valign: .top)
            case .down:
                toastView.frame.origin.y =
                    view.frame.height - toastView.frame.height
                    - margin - getExtraMargin(orientation: .down, valign: .top)
            }
        case .bottom:
            switch angle.1 {
            case .up:
                toastView.frame.origin.y =
                    view.frame.height - toastView.frame.height
                    - margin - getExtraMargin(orientation: .up, valign: .bottom)
            case .left:
                toastView.frame.origin.x =
                    view.frame.width - toastView.frame.width
                    - margin - getExtraMargin(orientation: .left, valign: .bottom)
            case .right:
                toastView.frame.origin.x =
                    margin + getExtraMargin(orientation: .right, valign: .bottom)
            case .down:
                toastView.frame.origin.y =
                    margin + getExtraMargin(orientation: .down, valign: .bottom)
            }
        default:
            break
        }

        textLabel.center = CGPoint(x: toastView.frame.width/2, y: toastView.frame.height/2)
    }
}

extension TinyToastViewController {
    // Create Label
    private func createMessageLabel(message: String) -> UILabel {
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 12, y: 9, width: labelWidth, height: 10))
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.isUserInteractionEnabled = false
        messageLabel.text = message
        messageLabel.font = textFont
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        return messageLabel
    }
    
    // Create Toast View
    private func createToastView(messageLabelWidth: CGFloat, messageLabelHeight: CGFloat) -> UIView {
        let toastView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: messageLabelWidth + 44, height: messageLabelHeight + 16))
        toastView.isUserInteractionEnabled = false
        toastView.layer.cornerRadius = toastView.frame.height/2
        return toastView
    }
    
    // Rotate Toast View
    /**
     * View does not rotate automatically, so it fits the screen.
     */
    private func getAngle(orientation: UIInterfaceOrientation) -> (CGFloat, TinyToastDisplayDirection) {
        switch orientation {
        case .portrait, .landscapeLeft, .landscapeRight:
            return (CGFloat(0.0 * CGFloat.pi / 180.0), .up)
        case .portraitUpsideDown:
            return (CGFloat(180.0 * CGFloat.pi / 180.0), .down)
        default:
            return (CGFloat(0.0 * CGFloat.pi / 180.0), .up)
        }
    }
    
    func getExtraMargin(orientation: TinyToastDisplayDirection, valign: TinyToastDisplayVAlign) -> CGFloat {
        switch orientation {
        case .up:
            switch valign {
            case .top:
                return UIApplication.shared.statusBarFrame.size.height > 0.0
                    ? UIApplication.shared.statusBarFrame.size.height - 14.0 : 0.0
            case .bottom:
                if #available(iOS 11.0, *) {
                    return UIApplication.shared.keyWindow!.safeAreaInsets.bottom > 0.0
                        ? UIApplication.shared.keyWindow!.safeAreaInsets.bottom - 14.0 : 0.0
                } else {
                    return 0.0
                }
            default:
                return 0.0
            }
        case .left, .right:
            switch valign {
            case .top:
                return 0.0
            case .bottom:
                if #available(iOS 11.0, *) {
                    return UIApplication.shared.keyWindow!.safeAreaInsets.bottom > 0.0
                        ? UIApplication.shared.keyWindow!.safeAreaInsets.bottom - 6.0 : 0.0
                } else {
                    return 0.0
                }
            default:
                return 0.0
            }
        default:
            return 0.0
        }
    }
}
