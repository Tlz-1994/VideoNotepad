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

@objc public protocol AudioManagerDelegate: class {
    @objc optional func starPlayWithFilePath(_ filePath: String?)
    @objc optional func pausePlayWithFilePath(_ filePath: String?)
    @objc optional func finishPlayWithFilePath(_ filePath: String?)
    @objc optional func currentRecordVolume(_ volume: String?)
}

public class AudioManager: NSObject {
    
    // 单例方法
    static let manager = AudioManager.init()
    
    // 代理
    weak open var delegate: AudioManagerDelegate?
    
    private let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),
                                                AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
                                                AVLinearPCMBitDepthKey: NSNumber(value: 16),
                                                AVNumberOfChannelsKey: NSNumber(value: 1),
                                                AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)
    ];
    private var recorder: AVAudioRecorder?         // 录音器
    private var timer: CADisplayLink?
    private var player: AVAudioPlayer?
    private let rootFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/")
    private let temfilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/recordtem.wav")   // 保存临时录音文件的位置
    
    fileprivate var currentPlayFilePath: String?
    
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
    
    // 初始化音量监听器
    private func setUpMoitor() {
        timer?.invalidate()
        timer = CADisplayLink(target: self, selector: #selector(updateTimer))
        timer?.add(to: .current, forMode: .commonModes)
        recorder!.isMeteringEnabled = true
    }
    
    @objc private func updateTimer() {
        recorder?.updateMeters()
        let power = recorder?.peakPower(forChannel: 0)
        if (power != nil) {
            delegate?.currentRecordVolume?("\(pow(10, 0.05 * power!))")
        }
    }
    
    // 开始录音
    public func beginRecord() {
        // 开始录音
        do {
            pause() // 如果有正在播放的音频，暂停播放
            let url = URL(fileURLWithPath: temfilePath!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            setUpMoitor()
            print("开始录音")
        } catch let error {
            print("录音失败:\(error.localizedDescription)")
        }
    }
    
    
    // 结束录音, 并返回音频的保存位置
    public func stopRecord() -> String {
        if let recorder = self.recorder {
            if recorder.isRecording {
                recorder.stop()
            }
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
        if (player != nil) {
            if (player?.isPlaying)! {
                player?.pause()
                delegate?.pausePlayWithFilePath?(currentPlayFilePath)
            }
        }
    }
    
    // 恢复播放
    public func resume() {
        player?.play()
        delegate?.starPlayWithFilePath?(currentPlayFilePath)
    }
    
    // 播放
    public func play(_ path: String) {
        timer?.invalidate()
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.delegate = self
            player?.play()
            delegate?.starPlayWithFilePath?(currentPlayFilePath)
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
            self.delegate?.finishPlayWithFilePath?(currentPlayFilePath!)
        }
    }
}

extension AudioManager {
    fileprivate func moveAudioToDocument(_ from: String) -> String {
        let fileManaget = FileManager.default
        let saveString = Tool.getRandomFileName()
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
