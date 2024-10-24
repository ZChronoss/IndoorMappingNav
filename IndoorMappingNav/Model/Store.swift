//
//  Store.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 07/10/24.
//

import Foundation
import CloudKit

class Store: Identifiable, CloudKitRecordInitializable {
    var id: Int64?
    var name: String?
    var category: StoreCategory?
    var address: String?
    var images: [CKAsset?]?
    var floor: String?
    var mallId: CKRecord.Reference?
    
    init(){
        
    }
    
    required init(record: CKRecord) {
        self.id = record["Id"] as? Int64
        self.name = record["Name"] as? String
        
        let categoryId = record["Category"] as? Int64
        
        self.category = getCategory(num: categoryId ?? 7)
        self.address = record["Address"] as? String
        self.images = record["Images"] as? [CKAsset?]
        self.floor = record["Floor"] as? String
        self.mallId = record["MallId"] as? CKRecord.Reference
    }
    
    func getCategory(num: Int64) -> StoreCategory {
        var category: StoreCategory
        
        switch num {
        case 1:
            category = StoreCategory(name: .toilet)
        case 2:
            category = StoreCategory(name: .fnb)
        case 3:
            category = StoreCategory(name: .shopping)
        case 4:
            category = StoreCategory(name: .service)
        case 5:
            category = StoreCategory(name: .hnb)
        case 6:
            category = StoreCategory(name: .entertainment)
        case 7:
            category = StoreCategory(name: .other)
        default:
            category = StoreCategory(name: .other)
        }
        return category
    }
}
