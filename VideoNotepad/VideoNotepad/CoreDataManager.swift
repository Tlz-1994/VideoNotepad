//
//  CoreDataManager.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/25.
//  Copyright © 2017年 Stefanie. All rights reserved.
//  COreData数据路操作管理类

import Foundation
import UIKit
import CoreData

public class CoreDataManager {
    
    private let entityName = "Record"
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK:数据库操作
    
    public func addRecord(_ record: RecordModel) {
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Record
        // add data
        newRecord.fileName = record.fileName!
        newRecord.filePath = record.filePath!
        
        // save data
        do {
            try context.save()
        } catch let error {
            print("插入失败:\(error.localizedDescription)")
        }
    }
    
    public func getAllRecord() -> [RecordModel] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        var records: [RecordModel] = [RecordModel]()
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [Record] {
                    let record = RecordModel()
                    record.fileName = result.fileName
                    record.filePath = result.filePath
                    records.append(record)
                }
            }
            return records
        } catch let error {
            print("查询失败:\(error.localizedDescription)")
            return records
        }
    }
    
}
