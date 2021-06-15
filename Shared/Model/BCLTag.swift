//
//  CLTag.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/14/21.
//

import CloudKit
import UIKit

struct BCLTag {
    static let kName = "name"
    
    let ckRecordID: CKRecord.ID
    let name: String
    
    init(record: CKRecord) {
        ckRecordID = record.recordID
        name = record[CLTag.kName] as? String ?? "N/A"
    }
}
