//
//  RecordModel.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/26.
//  Copyright © 2017年 Stefanie. All rights reserved.
//  记录的数据模型

import Foundation

enum PlayState: String {
    case Playing = "正在播放中"
    case Pause   = "已暂停"
    case Normal  = "点击播放"
}

public class RecordModel {
    var fileName: String?
    var filePath: String?          // 只保存文件的保存名称，播放时拼接真实的path
    var playState: PlayState = .Normal
}
