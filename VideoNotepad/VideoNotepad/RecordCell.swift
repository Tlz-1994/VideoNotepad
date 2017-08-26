//
//  RecordCell.swift
//  VideoNotepad
//
//  Created by stefanie on 2017/8/26.
//  Copyright © 2017年 Stefanie. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var recordNameLabel: UILabel!
    @IBOutlet weak var playStateLabel: UILabel!
    
    private var _record: RecordModel?
    public var record: RecordModel? {
        get {
            return _record
        }
        set {
            _record = newValue
            recordNameLabel.text = newValue?.fileName
            playStateLabel.text = newValue?.playState.rawValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
