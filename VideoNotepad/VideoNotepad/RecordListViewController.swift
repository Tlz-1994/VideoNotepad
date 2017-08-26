//
//  RecordListViewController.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/26.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import UIKit
import Foundation

class RecordListViewController: UIViewController, AudioManagerDelegate {
    
    fileprivate lazy var dataSource: [RecordModel] = {
        return CoreDataManager().getAllRecord()
    }()

    private var tableView: UITableView = {
        let tabeleView = UITableView(frame: CGRect.zero, style: .plain)
        tabeleView.register(UINib(nibName: "RecordCell", bundle: nil), forCellReuseIdentifier: "cell")
        return tabeleView
    }()
    
    fileprivate lazy var currentRecord: RecordModel = {
        return RecordModel()
    }() // 当前正在操作的RecordModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadMainUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 初始化数据
    private func loadDataSource() {
        dataSource = CoreDataManager().getAllRecord()
        tableView.reloadData()
    }
    
    // MARK: 创建UI
    private func loadMainUI() {
        view.backgroundColor = UIColor.white
        title = "记录列表"
        
        // 创建列表
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        // 设置代理
        AudioManager.manager.delegate = self
    }
    
    // 根绝AudioManager的回调判断当前每个record的状态
    func starPlayWithFilePath(_ filePath: String?) {
        currentRecord.filePath = filePath
        currentRecord.playState = .Playing
        tableView.reloadData()
    }
    
    func pausePlayWithFilePath(_ filePath: String?) {
        currentRecord.filePath = filePath
        currentRecord.playState = .Pause
        tableView.reloadData()
    }
    
    func finishPlayWithFilePath(_ filePath: String?) {
        currentRecord.filePath = filePath
        currentRecord.playState = .Normal
        tableView.reloadData()
    }

}

extension RecordListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecordCell
        let record = dataSource[indexPath.row]
        cell.recordNameLabel.text = record.fileName
        cell.playStateLabel.text = record.playState.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 播放
        let record = dataSource[indexPath.row]
        currentRecord = record
        AudioManager.manager.playWithSuffix(record.filePath!)
    }
    
}

