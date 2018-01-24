//
//  Entry.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/19/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Entry {
    
    fileprivate static var titleKey: String { return "title" }
    fileprivate static var textKey: String { return "text" }
    fileprivate static var timestampKey: String { return "timestamp" }
    fileprivate static var photoDataKey: String { return "photoData" }
    fileprivate static var badgeRefsKey: String { return "badgeRefs" }
    static var recordType: String { return "Entry" }
    
    let photoData: Data?
    let title: String
    let text: String
    let timestamp: Date
    let badgeRefs: [CKReference]
    
    var photo: UIImage {
        guard let photoData = photoData, let image = UIImage(data: photoData) else { return UIImage() }
        
        return image
    }
    
    var ckRecordID: CKRecordID?
    
    init(photoData: Data?, title: String, text: String, timestamp: Date = Date(), badges: [CKReference] = []) {
        
        self.photoData = photoData
        self.title = title
        self.text = text
        self.timestamp = timestamp
        self.badgeRefs = badges
    }
    
    init?(ckRecord: CKRecord) {
        guard let photoData = ckRecord[Entry.photoDataKey] as? Data,
        let title = ckRecord[Entry.titleKey] as? String,
        let text = ckRecord[Entry.textKey] as? String,
            let timestamp = ckRecord[Entry.timestampKey] as? Date else { return nil }
        
        self.photoData = photoData
        self.title = title
        self.text = text
        self.timestamp = timestamp
        self.badgeRefs = ckRecord[Entry.badgeRefsKey] as? [CKReference] ?? []
    }
}

extension Entry: Equatable {
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.photoData == rhs.photoData && lhs.title == rhs.title && lhs.text == rhs.text && lhs.timestamp == rhs.timestamp && lhs.badgeRefs == rhs.badgeRefs
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        let recordID = entry.ckRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: Entry.recordType, recordID: recordID)
        
        if entry.badgeRefs == [] {
        } else {
            self.setValue(entry.badgeRefs, forKey: Entry.badgeRefsKey)
        }
        
        self.setValue(entry.photoData, forKey: Entry.photoDataKey)
        self.setValue(entry.title, forKey: Entry.titleKey)
        self.setValue(entry.text, forKey: Entry.textKey)
        self.setValue(entry.timestamp, forKey: Entry.timestampKey)
    }
}
