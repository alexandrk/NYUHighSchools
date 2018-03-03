//
//  SchoolsViewController.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 2/28/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit

class SchoolsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private static let cellIdentifier = "schoolCell"
  
  // store API returned data and data filtered with searchController
  private var schools = [School]()
  private var filteredSchools = [School]()
  
  // Use to query the API for schools list
  public var boro: String!
  
  // Use to filter API data by name / city / zip
  let searchController = UISearchController(searchResultsController: nil)
  
  // Custom footer view, used to display number of items returned by searchController
  let searchFooter: SearchFooter = {
    let view = SearchFooter()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Use UITableView as a View instead of UITableViewController, since UITableViewController
  // doesn't implement safeLayoutGuides [used for layout on iPhone X]
  let tableView: UITableView = {
    let view = UITableView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    layoutViews()
    
    // Get navigation title from `boro` lookup
    navigationItem.title = titleFromBoro(boro: boro)
    
    // TableView Setup
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: SchoolsViewController.cellIdentifier)
    
    // Use to make cell height auto-adjustable based on the cell content
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    
    // Search Controller Setup
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search schools by name, city or zip code"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    // Scope Bar Setup [appears underneath search bar]
    searchController.searchBar.scopeButtonTitles = ["Name", "City", "Zip Code"]
    searchController.searchBar.delegate = self
    
    // Custom Footer Setup
    tableView.tableFooterView = searchFooter
    
    // Request Schools Data from API
    Networking.requestSchools(boro: boro) { (result, error) in
      if let result = result, result.count > 0 {
        self.schools = result
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      } else if let error = error {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
        }
      } else {
        let errorMessage = "No Schools Founds. The provided resource can be offline."
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
  // MARK: - TablewView Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  // numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Count element from two distinct lists [Full or Filtered]
    if isFiltering() {
      searchFooter.setIsFilteringToShow(filteredItemCount: filteredSchools.count, of: schools.count)
      return filteredSchools.count
    }
    searchFooter.setNotFiltering()
    return schools.count
  }
  
  // cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCell(withIdentifier: SchoolsViewController.cellIdentifier, for: indexPath)
    if cell.detailTextLabel == nil {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: SchoolsViewController.cellIdentifier)
    }
    
    // Text Label Setup
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 13)
    
    // Select School from one of two lists [Full|Filtered] based on isFiltering trigger
    let school: School
    if isFiltering() {
      school = filteredSchools[indexPath.row]
    } else {
      school = schools[indexPath.row]
    }
    cell.textLabel?.text = school.school_name
    cell.detailTextLabel?.text = "\(school.primary_address_line_1), \(school.city) \(school.state_code) \(school.zip)"
    
    return cell
  }
  
  // didSelectRowAt
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailsTableViewController()
    let school: School
    
    if isFiltering() {
      school = filteredSchools[indexPath.row]
    } else {
      school = schools[indexPath.row]
    }
    vc.school = school
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Private instance methods
  private func layoutViews() {
    view.addSubview(tableView)
    view.addSubview(searchFooter)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      
      searchFooter.widthAnchor.constraint(equalTo: tableView.widthAnchor),
      searchFooter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      searchFooter.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  // Title Lookup based on `boro` passed from previous controller
  private func titleFromBoro(boro: String) -> String {
    var title = ""
    switch boro {
    case "Q": title = "Queens"
    case "M": title = "Manhattan"
    case "X": title = "Bronx"
    case "K": title = "Brooklyn"
    case "R": title = "Staten Island"
    default: fatalError("titleFromBoro(boro:) Unrecognized boro")
    }
    return title
  }
  
  // Determines if the search is active
  private func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }
  
  private func searchBarIsEmpty() -> Bool {
    // Returns true if the text is empty or nil
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  private func filterContentForSearchText(_ searchText: String, scope: String = "Name") {
    filteredSchools = schools.filter({( school : School) -> Bool in
      
      switch scope {
      case "City": return school.city.lowercased().contains(searchText.lowercased())
      case "Zip Code": return school.zip.contains(searchText)
      default: return school.school_name.lowercased().contains(searchText.lowercased())
      }
    })
    
    tableView.reloadData()
  }
  
}

// MARK: - Extensions to provide search functionality
extension SchoolsViewController: UISearchResultsUpdating {
  // UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchBar.text!, scope: scope)
  }
}

extension SchoolsViewController: UISearchBarDelegate {
  // UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}
