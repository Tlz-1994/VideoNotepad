//
//  Tool.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/26.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import Foundation
import UIKit

class Tool {
    
    private static let characters = ["e", "r", "F", "🐓", "🐯", "%", "G", "你", "是", "看", "发", "个", "u", "人", "1", "配", "福", "他", "图", "推", "平", "并", "没", "好", "爱", "来", "🐓", "🐯", "🐑"]
    
    // 返回一下随机的name
    public class func getRandomName() -> String! {
        var ranStr = ""
        for _ in 0..<6 {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            ranStr.append(characters[index])
        }
        return ranStr
    }
    
    // 根据时间戳,返回一个该时间戳的文件名
    public class func getRandomFileName() -> String {
        let now = Date()
        let dateString = String(now.timeIntervalSince1970)
        let saveString = dateString.appending(".wav")
        return saveString
    }
    
    // 提示没有录音权限弹窗
    public class func alertNoJurisdictionFromController(_ controller: UIViewController) {
        let alert = UIAlertController.init(title: "提醒", message: "您没有开启使用麦克风的权限，请在设置中打开该权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "去设置", style: .default, handler: { (action) in
            UIApplication.shared.open(URL.init(string: "App-Prefs:root=General")!, options: [:], completionHandler: { (isOpen) in
                
            })
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    // 打印的设置:(https://onevcat.com/2016/02/swift-performance/)
    public class func dPrint(_ item: @autoclosure () -> Any) {
        #if DEBUG
            print(item())
        #endif
    }
}
