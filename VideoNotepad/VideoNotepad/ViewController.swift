//
//  ViewController.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/25.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recordBtn: UIButton!
    
    private let audioManager: AudioManager = {
        return AudioManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bindButtonClickAction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 绑定按钮的点击事件
    func bindButtonClickAction() {
        recordBtn.addTarget(self, action: #selector(beginRecord), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(endRecordAndPlay), for: .touchUpInside)
    }
    
    @objc private func beginRecord() {
        audioManager.beginRecord()
    }
    
    @objc private func endRecordAndPlay() {
        audioManager.stopRecord()
        audioManager.play()
        // 存储这条音频的数据
        let record = Record()
        record.fileName = "12345"
        record.filePath = "/record.wav"
        CoreDataManager().addRecord(record)
    }

}

