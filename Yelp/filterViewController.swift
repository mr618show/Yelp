//
//  filterViewController.swift
//  Yelp
//
//  Created by Rui Mao on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class filterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

}
