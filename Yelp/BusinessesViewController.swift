//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Rui Mao on 4/5/17.
//  Copyright (c) 2017 Rui Mao. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, filterViewControllerDelegate, UISearchResultsUpdating {
    
    var businesses: [Business]!
    var filteredData: [Business] = []
    var searchController: UISearchController!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    self.tableView.reloadData()
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        //filteredData = (businesses?)!
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
            /*if businesses != nil {
            return businesses!.count
            }
            else {
                return 0
            }*/
        return filteredData.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath as IndexPath) as! BusinessCell
            
            cell.business = filteredData[indexPath.row]
            return cell
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filteredData = searchText.isEmpty ? self.businesses! : self.businesses.filter({(business: Business) -> Bool in
                return (business.name)?.range(of: searchText, options: .caseInsensitive) != nil
                })
            tableView.reloadData()
        }
    }
    
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterViewController =
        navigationController.topViewController as! filterViewController
        filterViewController.delegate = self
    }
    
    func filterViewController(filterViewController: filterViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil) {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
}
