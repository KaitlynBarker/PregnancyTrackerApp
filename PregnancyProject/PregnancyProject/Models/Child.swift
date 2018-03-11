//
//  Child.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/19/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Child {
    
    fileprivate static var nameKey: String { return "name" }
    static var dateOfBirthKey: String { return "dateOfBirth" }
    fileprivate static var badgeRefsKey: String { return "badgeRefs" }
    fileprivate static var ageKey: String { return "age" }
    fileprivate static var genderKey: String { return "gender" }
    fileprivate static var entryRefsKey: String { return "entryRefs" }
    fileprivate static var photoDataKey: String { return "photoData" }
    static var recordType: String { return "Child" }
    
    var name: String
    var dateOfBirth: Date
    let badgeRefs: [CKReference]
    var age: Int
    var gender: String
    let entryRefs: [CKReference]
    var photoData: Data?
    
    var photo: UIImage {
        guard let photoData = photoData, let image = UIImage(data: photoData) else { return UIImage() }
        
        return image
    }
    
    var ckRecordID: CKRecordID?
    
    init(name: String, dateOfBirth: Date, badges: [CKReference] = [], age: Int, gender: String, entries: [CKReference] = [], photoData: Data?) {
        
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.badgeRefs = badges
        self.age = age
        self.gender = gender
        self.entryRefs = entries
        self.photoData = photoData
    }
    
    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Child.nameKey] as? String,
        let dateOfBirth = ckRecord[Child.dateOfBirthKey] as? Date,
        let age = ckRecord[Child.ageKey] as? Int,
        let gender = ckRecord[Child.genderKey] as? String,
            let photoData = ckRecord[Child.photoDataKey] as? Data else { return nil }
        
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.age = age
        self.gender = gender
        self.photoData = photoData
        self.badgeRefs = ckRecord[Child.badgeRefsKey] as? [CKReference] ?? []
        self.entryRefs = ckRecord[Child.entryRefsKey] as? [CKReference] ?? []
    }
}

extension Child: Equatable {
    static func ==(lhs: Child, rhs: Child) -> Bool {
        return lhs.name == rhs.name && lhs.dateOfBirth == rhs.dateOfBirth && lhs.badgeRefs == rhs.badgeRefs && lhs.age == rhs.age && lhs.gender == rhs.gender && lhs.entryRefs == rhs.entryRefs && lhs.photoData == rhs.photoData
    }
}

extension CKRecord {
    convenience init(child: Child) {
        let recordID = child.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Child.recordType, recordID: recordID)
        
        if child.badgeRefs == [] {
        } else {
            self.setValue(child.badgeRefs, forKey: Child.badgeRefsKey)
        }
        
        if child.entryRefs == [] {
        } else {
            self.setValue(child.entryRefs, forKey: Child.entryRefsKey)
        }
        
        self.setValue(child.name, forKey: Child.nameKey)
        self.setValue(child.dateOfBirth, forKey: Child.dateOfBirthKey)
        self.setValue(child.age, forKey: Child.ageKey)
        self.setValue(child.gender, forKey: Child.genderKey)
        self.setValue(child.photoData, forKey: Child.photoDataKey)
    }
}
