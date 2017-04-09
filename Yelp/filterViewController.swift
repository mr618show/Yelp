//
//  filterViewController.swift
//  Yelp
//
//  Created by Rui Mao on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol filterViewControllerDelegate {
    @objc optional func filterViewController (filterViewController: filterViewController, didUpdateFilters filters: [String: AnyObject])
}

class filterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var categories: [[String: String]]!
    var switchStates = [Int:Bool]()
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: filterViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //categories = yelpCategories()
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        
        for (row,isSelected) in switchStates{
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        delegate?.filterViewController?(filterViewController: self, didUpdateFilters: filters)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! filterCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func filterCell(filterCell: filterCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: filterCell)!
        switchStates[indexPath.row] = value
        print ("filter view controller got the switch event")
    }
 */
    
    
}
