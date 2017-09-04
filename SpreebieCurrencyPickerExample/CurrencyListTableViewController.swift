//
//  CurrencyListTableViewController.swift
//  SpreebieCurrencyPickerExample
//
//  Created by Thabo David Klass on 01/09/2017.
//  Copyright © 2017 Open Beacon. All rights reserved.
//

import UIKit

class CurrencyListTableViewController: UITableViewController {
    /// The search bar
    let searchController = UISearchController(searchResultsController: nil)
    
    /// The currency data parsed from the JSON currency file
    let currencyData = NSData(contentsOfFile: Bundle.main.path(forResource: "currencies", ofType: "json")!)
    
    /// The currencies as a JSON object
    var currencies: JSON?
    
    /// The currencies filtered based on what is typed in the search bar
    var filteredCurrencies = [JSON]()
    
    /// The origin view controller
    weak var vc = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Set the navigation graphic primitives to a light blue color
        let lightBlue = UIColor(red: 0.0/255.0, green: 162.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: lightBlue]
        
        /// Do the actual JSON parsing
        do {
            currencies = try JSON(data: currencyData! as Data)
        } catch {
            // Do nothing for now
        }
        
        /// Search bar interaction - make it visible from the get-go
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearch(searchText: String) {
        filteredCurrencies = currencies!.array!.filter { currency in
            return currency["name"].stringValue.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCurrencies.count
        }
        
        return currencies!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        
        var data: JSON
        
        if searchController.isActive && searchController.searchBar.text != "" {
            data = filteredCurrencies[indexPath.row]
        }  else {
            data = currencies![indexPath.row]
        }
        
        let currencyName = data["name"].stringValue
        let currencySymbol = data["symbol"].stringValue
        
        cell.textLabel?.text = currencyName
        cell.detailTextLabel?.text = currencySymbol
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        vc!.currencyButton.setTitle("Currency - \(String(describing: cell!.textLabel!.text!)) (\(String(describing: cell!.detailTextLabel!.text!)))", for: UIControlState())
        
        var data: JSON
        
        if searchController.isActive && searchController.searchBar.text != "" {
            data = filteredCurrencies[indexPath.row]
        } else {
            data = currencies![indexPath.row]
        }
        
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
     }
    
    @IBAction func backBarButtonItemTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CurrencyListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearch(searchText: searchController.searchBar.text!)
    }
}
