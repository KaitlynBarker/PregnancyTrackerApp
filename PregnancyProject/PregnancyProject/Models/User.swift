//
//  User.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/19/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

class User {
    
    fileprivate static var nameKey: String { return "name" }
    fileprivate static var partnersNameKey: String { return "partnersName" }
    fileprivate static var emailKey: String { return "email" }
    fileprivate static var childRefsKey: String { return "childRefs" }
    fileprivate static var pregnancyRefsKey: String { return "pregnancyRefs" }
    fileprivate static var appleUserRefKey: String { return "appleUserRef" }
    static var recordType: String { return "User" }
    
    var name: String
    var partnersName: String?
    var email: String
    let childRefs: [CKReference]
    let pregnancyRefs: [CKReference]
    
    let appleUserRef: CKReference
    var ckRecordID: CKRecordID?
    
    init(name: String, partnersName: String?, email: String, childRefs: [CKReference] = [], pregnancyRefs: [CKReference] = [], appleUserRef: CKReference) {
        self.name = name
        self.partnersName = partnersName
        self.email = email
        self.childRefs = childRefs
        self.appleUserRef = appleUserRef
        self.pregnancyRefs = pregnancyRefs
    }
    
    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[User.nameKey] as? String,
            let partnersName = ckRecord[User.partnersNameKey] as? String,
        let email = ckRecord[User.emailKey] as? String,
            let appleUserRef = ckRecord[User.appleUserRefKey] as? CKReference else { return nil }
        
        self.name = name
        self.partnersName = partnersName
        self.email = email
        self.childRefs = ckRecord[User.childRefsKey] as? [CKReference] ?? []
        self.pregnancyRefs = ckRecord[User.pregnancyRefsKey] as? [CKReference] ?? []
        self.appleUserRef = appleUserRef
    }
}

extension CKRecord {
    convenience init(user: User) {
        let recordID = user.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: User.recordType, recordID: recordID)
        
        if user.childRefs == [] {
        } else {
            self.setValue(user.childRefs, forKey: User.childRefsKey)
        }
        
        if user.pregnancyRefs == [] {
        } else {
            self.setValue(user.pregnancyRefs, forKey: User.pregnancyRefsKey)
        }
        
        self.setValue(user.name, forKey: User.nameKey)
        self.setValue(user.partnersName, forKey: User.partnersNameKey)
        self.setValue(user.email, forKey: User.emailKey)
        self.setValue(user.appleUserRef, forKey: User.appleUserRefKey)
    }
}
