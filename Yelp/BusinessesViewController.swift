//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {

    let searchBar = UISearchBar()
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchedMovies: [String: AnyObject]?
    var searchedTerm = "";
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        // Use whatever autoconstrained layouts told you to do
        tableView.rowHeight = UITableViewAutomaticDimension
        // Used in conjunction with above
        tableView.estimatedRowHeight = 120

        // Set up search bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
//        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            
//            for business in businesses {
//                println(business.name!)
//                println(business.address!)
//            }
//        })
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in

            self.businesses = businesses
            self.setUpFilteredBusinesses()

            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
    }
    
    func setUpFilteredBusinesses() {
        if self.searchedTerm.characters.count == 0 {
            self.filteredBusinesses = self.businesses
        } else {
            self.filteredBusinesses = self.filterOnSearch(self.searchedTerm)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView Protocol Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredBusinesses = filteredBusinesses {
            return filteredBusinesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.business = filteredBusinesses[indexPath.row]
//        cell.delegate = self
        
        return cell
    }
  
    // Mark: - SearchBar - protocol
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterOnSearch(searchText)
        tableView.reloadData()
    }
    
    // Search-related function
    func filterOnSearch(searchText: String) -> [Business] {
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({ (business: Business) -> Bool in
            let stringMatch = (business.name)?.rangeOfString(searchText, options: .CaseInsensitiveSearch)
            return (stringMatch != nil)
        })
        return filteredBusinesses
    }
  
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController

        filtersViewController.delegate = self
    }

    // Navigation-related function
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let selectedCategories = filters["categories"] as? [String]
        let selectedDeals = filters["deals"] as? Bool
        print(selectedDeals)
        Business.searchWithTerm("Restaurants", sort: nil, categories: selectedCategories, deals: selectedDeals) { (businesses: [Business]!,
            error: NSError!) -> Void in
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        }
    }
}
