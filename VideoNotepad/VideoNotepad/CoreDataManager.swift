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
    
    public func addRecord(_ record: Record) {
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        // add data
        newRecord.setValue("fileName", forKey: record.fileName!)
        newRecord.setValue("filePath", forKey: record.filePath!)
        
        // save data
        do {
            try context.save()
        } catch let error {
            print("播放失败:\(error.localizedDescription)")
        }
    }
    
}
