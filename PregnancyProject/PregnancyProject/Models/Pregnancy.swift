//
//  Pregnancy.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class Pregnancy {
    // possibly have a badge array
    
    fileprivate static var nameKey: String { return "name" }
    fileprivate static var dueDateKey: String { return "dueDate" }
    fileprivate static var entryRefsKey: String { return "entryRefs" }
    static var recordType: String { return "Pregnancy" }
    
    let name: String
    let dueDate: Date
    let entryRefs: [CKReference]
    
    var ckRecordID: CKRecordID?
    
    init(name: String, dueDate: Date, entryRefs: [CKReference] = []) {
        self.name = name
        self.dueDate = dueDate
        self.entryRefs = entryRefs
    }
    
    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Pregnancy.nameKey] as? String,
            let dueDate = ckRecord[Pregnancy.dueDateKey] as? Date else { return nil }
        
        self.name = name
        self.dueDate = dueDate
        self.entryRefs = ckRecord[Pregnancy.entryRefsKey] as? [CKReference] ?? []
    }
}

extension Pregnancy: Equatable {
    static func ==(lhs: Pregnancy, rhs: Pregnancy) -> Bool {
        return lhs.name == rhs.name && lhs.dueDate == rhs.dueDate && lhs.entryRefs == rhs.entryRefs
    }
}

extension CKRecord {
    convenience init(pregnancy: Pregnancy) {
        let recordID = pregnancy.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Pregnancy.recordType, recordID: recordID)
        
        if pregnancy.entryRefs == [] {
        } else {
            self.setValue(pregnancy.entryRefs, forKey: Pregnancy.entryRefsKey)
        }
        
        self.setValue(pregnancy.name, forKey: Pregnancy.nameKey)
        self.setValue(pregnancy.dueDate, forKey: Pregnancy.dueDateKey)
    }
}
