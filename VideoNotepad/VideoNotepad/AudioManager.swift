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

public protocol AudioManagerDelegate: NSObjectProtocol {
    func starPlayWithFilePath(_ filePath: String?)
    func pausePlayWithFilePath(_ filePath: String?)
    func finishPlayWithFilePath(_ filePath: String?)
}

public class AudioManager: NSObject {
    
    // 单例方法
    static let manager = AudioManager.init()
    private override init(){
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
    }
    
    // 代理
    weak open var delegate: AudioManagerDelegate?
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private let rootFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/")
    private let temfilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/recordtem.wav")   // 保存临时录音文件的位置
    
    fileprivate var currentPlayFilePath: String?
    
    // 开始录音
    public func beginRecord() {
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
            AVLinearPCMBitDepthKey: NSNumber(value: 16),
            AVNumberOfChannelsKey: NSNumber(value: 1),
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)
        ];
        
        // 开始录音
        do {
            let url = URL(fileURLWithPath: temfilePath!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let error {
            print("录音失败:\(error.localizedDescription)")
        }
    }
    
    
    // 结束录音, 并返回音频的保存位置
    public func stopRecord() -> String {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(temfilePath!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
            // 把音频从临时保存的位置移动到固定的位置
            return moveAudioToDocument(temfilePath!)
        }else {
            print("没有初始化")
            return ""
        }
    }
    
    // 暂停当前音频播放
    public func pause() {
        if (player?.isPlaying)! {
            player?.pause()
            self.delegate?.pausePlayWithFilePath(currentPlayFilePath)
        }
    }
    
    // 恢复播放
    public func resume() {
        player?.play()
    }
    
    // 播放
    public func play(_ path: String) {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.delegate = self
            player?.play()
            self.delegate?.starPlayWithFilePath(currentPlayFilePath)
        } catch let error {
            print("播放失败:\(error.localizedDescription)")
        }
    }
    
    // 通过一个文件后缀名播放
    public func playWithSuffix(_ path: String) {
        let realPath = rootFilePath?.appending(path)
        currentPlayFilePath = path
        play(realPath!)
    }

}

extension AudioManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (self.delegate != nil) {
            self.delegate?.finishPlayWithFilePath(currentPlayFilePath!)
        }
    }
}

extension AudioManager {
    fileprivate func moveAudioToDocument(_ from: String) -> String {
        let fileManaget = FileManager.default
        // 根据当前时间戳生成一个文件名
        let now = Date()
        let dateString = String(now.timeIntervalSince1970)
        let saveString = dateString.appending(".wav")
        let toPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(saveString)")
        do {
            try fileManaget.moveItem(atPath: from, toPath: toPath!)
            return saveString
        } catch let error {
            print("移动失败:\(error.localizedDescription)")
            return ""
        }
    }
}
