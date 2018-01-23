//
//  Badge.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/19/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class Badge {
    
    fileprivate static var nameKey: String { return "name" }
    fileprivate static var passedOffKey: String { return "passedOff" }
    fileprivate static var childRefsKey: String { return "childRefs" }
    fileprivate static var entryRefsKey: String { return "entryRefs" }
    static var recordType: String { return "Badge" }
    
    let name: String
    let passedOff: Bool
    let childRefs: [CKReference]
    let entryRefs: [CKReference]
    
    var ckRecordID: CKRecordID?
    
    init(name: String, passedOff: Bool = false, childRefs: [CKReference] = [], entryRefs: [CKReference] = []) {
        self.name = name
        self.passedOff = passedOff
        self.childRefs = childRefs
        self.entryRefs = entryRefs
    }
    
    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Badge.nameKey] as? String,
            let passedOff = ckRecord[Badge.passedOffKey] as? Bool else { return nil }
        
        self.name = name
        self.passedOff = passedOff
        self.childRefs = ckRecord[Badge.childRefsKey] as? [CKReference] ?? []
        self.entryRefs = ckRecord[Badge.entryRefsKey] as? [CKReference] ?? []
    }
}

extension CKRecord {
    convenience init(badge: Badge) {
        let recordID = badge.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Badge.recordType, recordID: recordID)
        
        if badge.childRefs == [] {
        } else {
            self.setValue(badge.childRefs, forKey: Badge.childRefsKey)
        }
        
        if badge.entryRefs == [] {
        } else {
            self.setValue(badge.entryRefs, forKey: Badge.entryRefsKey)
        }
        
        self.setValue(badge.name, forKey: Badge.nameKey)
        self.setValue(badge.passedOff, forKey: Badge.passedOffKey)
    }
}
