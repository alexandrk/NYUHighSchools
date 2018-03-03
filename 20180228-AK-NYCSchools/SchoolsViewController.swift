//
//  SchoolsViewController.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 2/28/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit

class SchoolsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // Data Array
  private var schools = [School]()
  private var filteredSchools = [School]()
  
  public var boro: String?
  
  let searchController = UISearchController(searchResultsController: nil)
  
  let searchFooter: SearchFooter = {
    let view = SearchFooter()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Using UITableView as a View instead of using the UITableViewController, since UITableViewController
  // doesn't implement safeLayoutGuides (used for development for iPhone X)
  let tableView: UITableView = {
    let view = UITableView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    layoutViews()
    
    navigationItem.title = titleFromBoro(boro: boro)
    
    // Setup TableView
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.register(SchoolsTableViewCell.self, forCellReuseIdentifier: SchoolsTableViewCell.cellID)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    
    // Setup the Search Controller
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search schools by name or zip code"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    // Setup the Scope Bar
    searchController.searchBar.scopeButtonTitles = ["Name", "City", "Zip Code"]
    searchController.searchBar.delegate = self
    
    // Setup the search footer
    tableView.tableFooterView = searchFooter
    
    requestSchools()
    
  }
  
  // MARK: TABLEVIEW METHODS
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      searchFooter.setIsFilteringToShow(filteredItemCount: filteredSchools.count, of: schools.count)
      return filteredSchools.count
    }
    searchFooter.setNotFiltering()
    return schools.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: SchoolsTableViewCell.cellID,
                                             for: indexPath) as! SchoolsTableViewCell
    let school: School
    if isFiltering() {
      school = filteredSchools[indexPath.row]
    } else {
      school = schools[indexPath.row]
    }
    
    cell.schoolName.text = school.school_name
    cell.addressLabel1.text = "\(school.primary_address_line_1), \(school.city) \(school.state_code) \(school.zip)"
    
    return cell
  }
  
  // MARK: OTHER
  private func requestSchools() {
    
    guard let boro = self.boro else {
      /// TODO
      print("Boro is required in order to proceed")
      return
    }
    
    let client = SODAClient(domain: "data.cityofnewyork.us", token: "pMWYN2xWjHGuTWK18ZmHUq3Tj")
    
    // Default Socrata parameters to query the most recent version of the API back end
    let parameters: [String:String] = [
      "$$version": "2.1",
      "$$read_from_nbe": "true"
    ]
    
    let schoolList = client.query(dataset: "s3k6-pzi2", defaultParameters: parameters)
    
    schoolList.filter("boro like '%\(boro)%'").get { res in
      switch res {
      case .dataset (let data):
        
        do {
          self.schools = try JSONDecoder().decode([School].self, from: data)
          self.tableView.reloadData()
        } catch {
          print(error)
        }
        
      case .error (let error):
        
        print("Failure")
        print(error)
        
      }
    }
  }
  
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
  
  private func titleFromBoro(boro: String?) -> String {
    var title = "NYU Schools"
    
    guard let boro = boro else { return title }
    switch boro {
    case "Q":
      title = "Queens"
    case "M":
      title = "Manhattan"
    case "X":
      title = "Bronx"
    case "K":
      title = "Brooklyn"
    case "R":
      title = "Staten Island"
    default:
      title = ""
    }
    return title
  }
  
  // MARK: - Private instance methods
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
      case "City":
        return school.city.lowercased().contains(searchText.lowercased())
      case "Zip Code":
        return school.zip.contains(searchText)
      default:
        return school.school_name.lowercased().contains(searchText.lowercased())
      }
    })
    
    tableView.reloadData()
  }
  
}

extension SchoolsViewController: UISearchResultsUpdating {
  // MARK: UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchBar.text!, scope: scope)
  }
}

extension SchoolsViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}
