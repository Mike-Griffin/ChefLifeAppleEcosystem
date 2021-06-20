//
//  CLTag.swift
//  ChefLifeMultiPlat (iOS)
//
//  Created by Mike Griffin on 6/14/21.
//

import CloudKit
import UIKit

struct BCLTag: Identifiable {
    static let kName = "name"
    let id: CKRecord.ID
    let name: String
    init(record: CKRecord) {
        id = record.recordID
        name = record[BCLTag.kName] as? String ?? "N/A"
    }
    func convertToCKReference() -> CKRecord.Reference {
        return CKRecord.Reference(recordID: self.id, action: .none)
    }
}
