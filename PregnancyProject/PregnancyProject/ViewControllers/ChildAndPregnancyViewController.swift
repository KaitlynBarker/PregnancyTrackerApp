//
//  ChildAndPregnancyViewController.swift
//  PregnancyProject
//
//  Created by Kaitlyn Barker on 2/20/18.
//  Copyright © 2018 Kaitlyn Barker. All rights reserved.
//

import UIKit

class ChildAndPregnancyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pregListTableView: UITableView!
    @IBOutlet weak var childListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func createPregButton(_ sender: UIButton) {
        
    }
    
    @IBAction func createChildButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == pregListTableView {
            return PregnancyController.shared.pregnancies.count
        } else if tableView == childListTableView {
            return ChildController.shared.children.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pregnancyCell = tableView.dequeueReusableCell(withIdentifier: "pregnancyCell", for: indexPath) as? PregnancyTableViewCell, let childCell = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as? ChildTableViewCell else { return UITableViewCell() }
        
        let pregnancy = PregnancyController.shared.pregnancies[indexPath.row]
        let child = ChildController.shared.children[indexPath.row]
        
        if tableView == pregListTableView {
            pregnancyCell.pregnancy = pregnancy
            return pregnancyCell
        } else if tableView == childListTableView {
            childCell.child = child
            return childCell
        } else {
            return UITableViewCell()
        }
    }
    
    // Override to support editing the table view.
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == pregListTableView {
                let pregnancy = PregnancyController.shared.pregnancies[indexPath.row]
                PregnancyController.shared.deletePregnancy(pregnancy: pregnancy)
            } else if tableView == childListTableView {
                let child = ChildController.shared.children[indexPath.row]
                ChildController.shared.deleteChild(child: child)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        // MIGHT NOT WORK. CHECK IF DELETING DOESN'T WORK OR CAUSES CRASHES
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

/*
 
*/
