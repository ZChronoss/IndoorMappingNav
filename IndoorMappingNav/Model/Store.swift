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
    var category: StoreCategory?
    var address: String?
    var description: String? = nil
    
    // Asset Property
    var images: [Data?]?
    var logo: Data? = nil
    
    var floor: String?
    var mallId: CKRecord.Reference?
    var subcategory: [String]?
    
    init(){
        self.id = CKRecord.ID(recordName: UUID().uuidString)
    }
    
    required init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["Name"] as? String
        
        let categoryId = record["Category"] as? Int64
        self.category = getCategory(num: categoryId ?? 7)
        
        self.description = record["Description"] as? String
        self.address = record["Address"] as? String
        
        let imagesRecord = record["Images"] as? [CKAsset?]
        let logoRecord = record["Logo"] as? CKAsset
        
        self.images = processImage(imageRecords: imagesRecord)
        self.logo = {
            var data = Data()
            if let url = logoRecord?.fileURL {
                data = try! Data(contentsOf: url)
            }
            return data
        }()
        
        self.floor = record["Floor"] as? String
        self.mallId = record["MallId"] as? CKRecord.Reference
        
        if let subcategoryData = record["Subcategory"] as? String {
            self.subcategory = subcategoryData.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
    
    private func processImage(imageRecords: [CKAsset?]?) -> [Data?] {
        var datas: [Data?] = []
        
        for image in imageRecords ?? [] {
            if let url = image?.fileURL {
                let data = try? Data(contentsOf: url)
                datas.append(data ?? nil)
            }
        }
        
        return datas
    }
    
    private func getCategory(num: Int64) -> StoreCategory {
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
            
        // ADA
        case 10:
            category = StoreCategory(name: .com)
        case 11:
            category = StoreCategory(name: .social)
        case 12:
            category = StoreCategory(name: .tech)
        case 13:
            category = StoreCategory(name: .game)
        case 14:
            category = StoreCategory(name: .inter)
        case 15:
            category = StoreCategory(name: .everyday)
            
        default:
            category = StoreCategory(name: .other)
        }
        return category
    }
}

