//
//  filtersTableViewController.swift
//  Yelp
//
//  Created by Rui Mao on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
protocol  filtersTableViewControllerDelegate {
    func didUpdateFilters (_ controller: filtersTableViewController)
}

class filtersTableViewController: UITableViewController {
    
    var delegate: filtersTableViewControllerDelegate?
    
    var model: YelpFilters?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        self.model = YelpFilters(instance: YelpFilters.instance)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        YelpFilters.instance.copyStateFrom(self.model!)
        self.delegate?.didUpdateFilters(self)
        //delegate?.filtersTableViewController?(filtersTableViewController: self, didUpdateFilters: filters)
    }


    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.model!.filters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let filter = self.model!.filters[section] as Filter
        if !filter.opened {
            if filter.type == FilterType.single {
                return 1
            } else if filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count {
                return filter.numItemsVisible! + 1
            }
        }
        return filter.options.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = self.model!.filters[section]
        let label = filter.label
        
        // Add the number of selected options for multiple-select filters with hidden options
        if filter.type == .multiple && filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count && !filter.opened {
            let selectedOptions = filter.selectedOptions
            return "\(label) (\(selectedOptions.count) selected)"
        }
        //self.tableView.reloadData()
        return label
    }
    
    func handleSwitchValueChanged(_ switchView: UISwitch) -> Void {
        let cell = switchView.superview as! UITableViewCell
        if let indexPath = self.tableView.indexPath(for: cell) {
            let filter = self.model!.filters[indexPath.section] as Filter
            let option = filter.options[indexPath.row]
            option.selected = switchView.isOn
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil) 
        
        let filter = self.model!.filters[indexPath.section] as Filter
        switch filter.type {
        case .single:
            if filter.opened {
                let option = filter.options[indexPath.row]
                cell.textLabel?.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                cell.textLabel?.text = filter.options[filter.selectedIndex].label
                cell.accessoryView = UIImageView(image: UIImage(named: "Dropdown"))
            }
        case .multiple:
            if filter.opened || indexPath.row < filter.numItemsVisible! {
                let option = filter.options[indexPath.row]
                cell.textLabel?.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                cell.textLabel?.text = "See All"
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.textLabel?.textColor = .darkGray
            }
        default:
            let option = filter.options[indexPath.row]
            cell.textLabel?.text = option.label
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let switchView = UISwitch(frame: CGRect(x:100, y:100, width:0, height: 0))
            switchView.onImage = UIImage(named:"Logo")
            switchView.isOn = option.selected
            switchView.onTintColor = UIColor(red: 73.0/255.0, green: 134.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            switchView.addTarget(self, action: #selector(filtersTableViewController.handleSwitchValueChanged(_:)), for: UIControlEvents.valueChanged)
            cell.accessoryView = switchView
            //cell.accessoryView = UIImageView(image: UIImage(named: "Logo"))
        }
        
        return cell


    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = self.model!.filters[indexPath.section]
        switch filter.type {
        case .single:
            if filter.opened {
                let previousIndex = filter.selectedIndex
                if previousIndex != indexPath.row {
                    filter.selectedIndex = indexPath.row
                    let previousIndexPath = IndexPath(row: previousIndex, section: indexPath.section)
                    self.tableView.reloadRows(at: [indexPath, previousIndexPath], with: .automatic)
                }
            }
            
            let opened = filter.opened;
            filter.opened = !opened;
            
            if opened {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }
            } else {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            }
        case .multiple:
            if !filter.opened && indexPath.row == filter.numItemsVisible {
                filter.opened = true
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            } else {
                let option = filter.options[indexPath.row]
                option.selected = !option.selected
                self.tableView.reloadRows(at: [indexPath as IndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
