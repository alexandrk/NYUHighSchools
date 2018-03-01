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
  private var schools: [School]?
  
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
    
    navigationItem.title = "NYU Schools"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero
    tableView.register(SchoolsTableViewCell.self, forCellReuseIdentifier: SchoolsTableViewCell.cellID)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    let client = SODAClient(domain: "data.cityofnewyork.us", token: "pMWYN2xWjHGuTWK18ZmHUq3Tj")
    requestSchools(client)
    
  }
  
  // MARK: TABLEVIEW METHODS
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return schools?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: SchoolsTableViewCell.cellID,
                                             for: indexPath) as! SchoolsTableViewCell
    
    if let schools = schools {
      cell.schoolName.text = schools[indexPath.row].school_name
      cell.boroughLabel.text = schools[indexPath.row].borough
      cell.addressLabel1.text = schools[indexPath.row].primary_address_line_1
      cell.addressLabel2.text = "\(schools[indexPath.row].city) \(schools[indexPath.row].state_code) \(schools[indexPath.row].zip)"
    }
    
    return cell
  }
  
  // MARK: OTHER
  private func requestSchools(_ client: SODAClient) {
    // Default Socrata parameters to query the most recent version of the API back end
    let parameters: [String:String] = [
      "$$version": "2.1",
      "$$read_from_nbe": "true"
    ]
    
    let schoolList = client.query(dataset: "s3k6-pzi2", defaultParameters: parameters)
    
    schoolList.filter("lower(borough) like '%queens%'").limit(100).get { res in
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
    
    NSLayoutConstraint.activate([
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])
  }
  
}
