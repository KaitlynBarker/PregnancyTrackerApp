//
//  ChildController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class ChildController {
    static let shared = ChildController()
    
    private let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var currentChild: Child?
    
    var children: [Child] = [] {
        didSet {
            DispatchQueue.main.async {
                // notification
            }
        }
    }
    
    // MARK: - Create
    
    func createChild(name: String, dateOfBirth: Date = Date(), age: Int, gender: String, image: UIImage?, completion: @escaping (Error?) -> Void /*either image array, or just the image that i have in create entry func*/) {
        
        guard let image = image, let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        
        let child = Child(name: name, dateOfBirth: dateOfBirth, age: age, gender: gender, photoData: data)
        let childRecord = CKRecord(child: child)
        
        cloudKitManager.saveRecord(childRecord) { (_, error) in
            defer { completion(error) }
            
            if let error = error {
                NSLog("Error saving record. \(#file) \(#function) \n\(error.localizedDescription)")
                return
            }
            self.children.append(child)
        }
    }
    
    // MARK: - Fetch
    
    func fetchChildren(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
//        let sortDescriptors = [NSSortDescriptor(key: Child.dateOfBirthKey, ascending: true)]
    }
    
    // MARK: - Update
    
    // MARK: - Delete
    
    
}
