//
//  AudioManager.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/25.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

// 音频播放和录制的管理类

import UIKit
import AVFoundation

public class AudioManager {
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/recordtem.wav")
    
    // 开始录音
    public func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        // 设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error{
            print("设置类型失败:\(error.localizedDescription)")
        }
        // 设置session动作
        do {
            try session.setActive(true)
        } catch let error {
            print("初始化动作失败:\(error.localizedDescription)")
        }
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
            AVLinearPCMBitDepthKey: NSNumber(value: 16),
            AVNumberOfChannelsKey: NSNumber(value: 1),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)
        ];
        
        // 开始录音
        do {
            let url = URL(fileURLWithPath: filePath!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let error {
            print("录音失败:\(error.localizedDescription)")
        }
    }
    
    
    // 结束录音
    public func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(filePath!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    
    // 播放
    public func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath!))
            print("录制时间：\(player!.duration)")
            player!.play()
        } catch let error {
            print("播放失败:\(error.localizedDescription)")
        }
    }

}
