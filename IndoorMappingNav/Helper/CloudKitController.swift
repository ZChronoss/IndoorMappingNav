//
//  CloudKitController.swift
//  IndoorMappingNav
//
//  Created by Renaldi Antonio on 08/10/24.
//

import Foundation
import CloudKit

class CloudKitController: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer.default()
        self.databasePublic = container.publicCloudDatabase
    }
    
    // ini buat fix bug
}
