//
//  Mall.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 14/10/24.
//

import CloudKit
import CoreLocation

protocol CloudKitRecordInitializable {
    init?(record: CKRecord)
}

class Mall: Identifiable, CloudKitRecordInitializable {
    var id: CKRecord.ID
    var name: String
    var mapModel: CKAsset?
    var address: CLLocation?
    
    required init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["Name"] as? String ?? "No Name"
        self.mapModel = record["MapModel"] as? CKAsset
        self.address = record["Address"] as? CLLocation
    }
}
