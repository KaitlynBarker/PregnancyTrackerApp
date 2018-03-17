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
    
    fileprivate static var nameKey: String { return "name" }
    static var dueDateKey: String { return "dueDate" }
    fileprivate static var entryRefsKey: String { return "entryRefs" }
    fileprivate static var badgeRefsKey: String { return "badgeRefs" }
    static var recordType: String { return "Pregnancy" }
    
    var name: String
    var dueDate: Date
    let entryRefs: [CKReference]
    let badgeRefs: [CKReference]
    
    var ckRecordID: CKRecordID?
    
    init(name: String, dueDate: Date, entryRefs: [CKReference] = [], badgeRefs: [CKReference] = []) {
        self.name = name
        self.dueDate = dueDate
        self.entryRefs = entryRefs
        self.badgeRefs = badgeRefs
    }
    
    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Pregnancy.nameKey] as? String,
            let dueDate = ckRecord[Pregnancy.dueDateKey] as? Date else { return nil }
        
        self.name = name
        self.dueDate = dueDate
        self.entryRefs = ckRecord[Pregnancy.entryRefsKey] as? [CKReference] ?? []
        self.badgeRefs = ckRecord[Pregnancy.badgeRefsKey] as? [CKReference] ?? []
    }
}

extension Pregnancy: Equatable {
    static func ==(lhs: Pregnancy, rhs: Pregnancy) -> Bool {
        return lhs.name == rhs.name && lhs.dueDate == rhs.dueDate && lhs.entryRefs == rhs.entryRefs && lhs.badgeRefs == rhs.badgeRefs
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
        
        if pregnancy.badgeRefs == [] {
        } else {
            self.setValue(pregnancy.badgeRefs, forKey: Pregnancy.badgeRefsKey)
        }
        
        self.setValue(pregnancy.name, forKey: Pregnancy.nameKey)
        self.setValue(pregnancy.dueDate, forKey: Pregnancy.dueDateKey)
    }
}
