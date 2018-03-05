//
//  ChildController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 1/22/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import Foundation
import CloudKit

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
    
    // MARK: - Fetch
    
    // MARK: - Update
    
    // MARK: - Delete
    
    
}
