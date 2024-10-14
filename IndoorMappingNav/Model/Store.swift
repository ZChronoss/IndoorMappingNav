//
//  Store.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 07/10/24.
//

import Foundation
import CloudKit

class Store: Identifiable, CloudKitRecordInitializable {
    var id: CKRecord.ID
    var name: String?
    var category: Int64?
    var address: String?
    var images: [CKAsset?]?
    var floor: String?
    var mallId: CKRecord.Reference?
    
    required init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["Name"] as? String
        self.category = record["Category"] as? Int64
        self.address = record["Address"] as? String
        self.images = record["Images"] as? [CKAsset?]
        self.floor = record["Floor"] as? String
        self.mallId = record["MallId"] as? CKRecord.Reference
    }
}
