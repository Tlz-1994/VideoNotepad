//
//  ViewController.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/25.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    private let audioManager: AudioManager = {
        return AudioManager.manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMainUI()
        bindButtonClickAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 创建UI
    private func loadMainUI() {
        title = "录音"
        
        // navigationController right item
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.titleLabel?.text = "记录列表"
        button.titleLabel?.textColor = UIColor.black
        button.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
//        let item = UIBarButtonItem.init(customView: button)
        let ri = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(pushAction))
        navigationItem.rightBarButtonItem = ri
        
    }
    
    // MARK: 绑定按钮的点击事件
    private func bindButtonClickAction() {
        recordBtn.addTarget(self, action: #selector(beginRecord), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(endRecordAndPlay), for: .touchUpInside)
    }
    
    @objc private func beginRecord() {
        audioManager.beginRecord()
    }
    
    @objc private func endRecordAndPlay() {
        let filePath = audioManager.stopRecord()
        audioManager.playWithSuffix(filePath)
        // 存储这条音频的数据
        let record = RecordModel()
        record.fileName = "12345"
        record.filePath = filePath
        CoreDataManager().addRecord(record)
    }
    
    @objc private func pushAction() {
        let listVC = RecordListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }

}

