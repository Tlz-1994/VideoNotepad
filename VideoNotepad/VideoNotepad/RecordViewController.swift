//
//  ViewController.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/25.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var shadowView: UIImageView!
    @IBOutlet weak var volumeIamageView: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    private var currentFilePath: String?
    
    private let audioManager: AudioManager = {
        return AudioManager.manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMainUI()
        bindButtonClickAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 创建UI
    private func loadMainUI() {
        title = "录音"
        
        // navigationController right item
        let rightItem = UIBarButtonItem.init(barButtonSystemItem: .compose, target: self, action: #selector(pushAction))
        navigationItem.rightBarButtonItem = rightItem
        
        // hidden
        playBtn.isHidden = true
        volumeIamageView.isHidden = true
        
    }
    
    // MARK: 绑定按钮的点击事件
    private func bindButtonClickAction() {
        recordBtn.addTarget(self, action: #selector(beginRecord), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(endRecordAndPlay), for: .touchUpInside)
        playBtn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
    }
    
    @objc private func beginRecord() {
        if audioManager.isCanRecord {
            volumeIamageView.isHidden = false
            playBtn.isHidden = true
            audioManager.beginRecord()
        } else {
            Tool.alertNoJurisdictionFromController(self)
        }
    }
    
    @objc private func endRecordAndPlay() {
        if audioManager.isCanRecord {
            volumeIamageView.isHidden = true
            let filePath = audioManager.stopRecord()
            currentFilePath = filePath
            playBtn.isHidden = false
            // 存储这条音频的数据
            let record = RecordModel()
            record.fileName = Tool.getRandomName()
            record.filePath = filePath
            CoreDataManager().addRecord(record)
        }
    }
    
    // 播放当前录制完音频
    @objc private func playAction() {
        audioManager.playWithSuffix(currentFilePath!)
    }
    
    @objc private func pushAction() {
        let listVC = RecordListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }

}

extension RecordViewController: AudioManagerDelegate {
 
    // MARK:AudioManager代理
    func finishPlayWithFilePath(_ filePath: String?) {
        
    }
    
    func currentRecordVolume(_ volume: String?) {
        let height = volumeIamageView.frame.size.height * (1 - CGFloat.init(Float(volume!)!))
        let width = volumeIamageView.frame.size.width
        let x = volumeIamageView.frame.origin.x
        let y = volumeIamageView.frame.origin.y
        UIView.animate(withDuration: 0.001) {
            self.shadowView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
    }
    
}

