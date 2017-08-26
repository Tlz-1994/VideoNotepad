//
//  Tool.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/26.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import Foundation

class Tool {
    
    private static let characters = ["e", "r", "F", "%", "G", "你", "是", "看", "发", "个", "u", "人", "1", "配", "马", "他", "图", "推", "平", "并", "没", "好", "菜", "来"]
    
    // 返回一下随机的name
    public class func getRandomName() -> String {
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
    
}
