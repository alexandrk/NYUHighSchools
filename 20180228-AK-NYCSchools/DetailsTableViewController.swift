//
//  DetailsTableViewController.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 3/2/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit
import MapKit

class DetailsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  static let cellIdentifier = "genericCell"
  
  var school: School!
  private var satScores: [SATScores]?
  
  // Using UITableView as a View instead of using the UITableViewController, since UITableViewController
  // doesn't implement safeLayoutGuides (used for development for iPhone X)
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
    
    navigationItem.title = "School Details"
    navigationController?.navigationBar.isTranslucent = false
    
    // TableView Setup
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: DetailsTableViewController.cellIdentifier)
    tableView.register(MapViewCell.self, forCellReuseIdentifier: MapViewCell.cellIdentifier)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    
    // Request Schools Data from API
    Networking.requestSATScores(schoolID: school.dbn) { (result, error) in
      if let result = result, result.count > 0 {
        self.satScores = result
        DispatchQueue.main.async {
          self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
      } else if let error = error {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
        }
      } else {
        let errorMessage = "No SAT Score data available"
        let alert = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        DispatchQueue.main.async {
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }

  // titleForHeaderInSection
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var returnValue:String!
    
    switch section {
    case 0: returnValue = "Name"
    case 1: returnValue = "Overview"
    case 2: returnValue = "Location"
    case 3: returnValue = "SAT Scores"
    case 4: returnValue = "Stats"
    default: fatalError("Unknown section in titleForHeaderInSection")
    }
    
    return returnValue
  }
  
  // numberOfRowsInSection
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var returnValue: Int!
    
    switch section {
      case 0: returnValue = 1 // Name
      case 1: returnValue = 1 // Overview
      case 2: returnValue = 4 // Location
      case 3: returnValue = 4 // SAT Scores
      case 4: returnValue = 4 // Stats
      default: fatalError("Unknown section in numberOfRowsInSection")
    }
    return returnValue
  }

  // cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell(style: .subtitle, reuseIdentifier: DetailsTableViewController.cellIdentifier)
  
    // Default cell settings
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.numberOfLines = 0
  
    // Switching on the section index to populate the static cells correctly
    switch indexPath.section {
      case 0: // Name Section
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = school.school_name
      
      case 1: // Overview Section
        cell.textLabel?.textAlignment = .justified
        cell.textLabel?.text = school.overview_paragraph
      
      case 2: // Location Section
        cell = renderLocationSectionRows(indexPath)
      case 3: // SAT Section
        cell = renderSATScoresRows(indexPath)
      case 4: // Stats Section
        cell = renderSTATSRows(indexPath)
      default: fatalError("cellForRowAt() Please check the number of sections in the table")
    }

    return cell
  }
  
  // MARK: - Private instance methods
  
  /**
   Renders rows for LOcation section
   */
  private func renderLocationSectionRows(_ indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell(style: .subtitle, reuseIdentifier: DetailsTableViewController.cellIdentifier)
    
    // Default cell settings
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.numberOfLines = 0
  
    switch indexPath.row {
      case 0: // Map Cell
        let mapCell = MapViewCell(style: .default, reuseIdentifier: MapViewCell.cellIdentifier)
      
        if let latString = school.latitude, let longString = school.longitude,
          let latitude = Double(latString), let longitude = Double(longString){
          let centerLocation = CLLocationCoordinate2DMake(latitude, longitude)
          let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
          let mapRegion = MKCoordinateRegion(center: centerLocation, span: mapSpan)
          let mapPin = MKPointAnnotation()
        
          mapPin.coordinate = centerLocation
          mapCell.mapView.addAnnotation(mapPin)
          mapCell.mapView.setRegion(mapRegion, animated: true)
        
          cell = mapCell
        } else {
          cell.textLabel?.text = "No School coordinates provided. Cannot render the map view."
        }
      case 1: // Address Cell
        cell.textLabel?.text = school.primary_address_line_1
        cell.detailTextLabel?.text = "\(school.city) \(school.state_code) \(school.zip)"
      case 2: // Phone Cell
        cell.textLabel?.text = "Phone Number:"
        cell.detailTextLabel?.text = "\(school.phone_number)"
      case 3: // Website Cell
        cell.textLabel?.text = "Website:"
        cell.detailTextLabel?.text = "\(school.website ?? "N/A")"
      default: fatalError("Unknown row in cellForRowAt for section \(indexPath.section)")
      }
      return cell
    }
  
  /**
   Renders rows for SAT Scores section
   */
  private func renderSATScoresRows(_ indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: DetailsTableViewController.cellIdentifier)
    
    // Default cell settings
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.numberOfLines = 0
    
    guard let satScores = satScores, satScores.count > 0 else {
      if indexPath.row == 0 {
        cell.textLabel?.text = "Sorry: No SAT Score data available."
      }
      return cell
    }
    
    // Default values for empty fields
    let numberOfTakers = satScores[0].num_of_sat_test_takers ?? "N/A"
    let criticalReading = satScores[0].sat_critical_reading_avg_score ?? "N/A"
    let math = satScores[0].sat_math_avg_score ?? "N/A"
    let writing = satScores[0].sat_writing_avg_score ?? "N/A"
    
    switch indexPath.row {
      case 0: cell.textLabel?.text = "Number of Takers: \(numberOfTakers)"
      case 1: cell.textLabel?.text = "Critical Reading Avg. Score: \(criticalReading)"
      case 2: cell.textLabel?.text = "Math Avg. Score: \(math)"
      case 3: cell.textLabel?.text = "Writing Avg. Score : \(writing)"
      default: fatalError("Unknown row in cellForRowAt for section \(indexPath.section)")
    }
    return cell
  }
  
  /**
   Renders rows for STATS section
  */
  private func renderSTATSRows(_ indexPath: IndexPath) -> UITableViewCell {
    var value = "N/A"
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: DetailsTableViewController.cellIdentifier)
    
    // Default cell settings
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.numberOfLines = 0
    
    switch indexPath.row {
      case 0: // Number of students Cell
        cell.textLabel?.text = "Number of Students: \(school.total_students)"
      case 1: // Attendance Rate Cell
        if let rate = school.attendance_rate, !rate.isEmpty, let numericRate = Double(rate) {
          value = String(format: "%1.2f", numericRate)
        }
        cell.textLabel?.text = "Attendence Rate: \(value)"
      case 2: // Graduation Rate Cell
        if let rate = school.graduation_rate, !rate.isEmpty, let numericRate = Double(rate) {
          value = String(format: "%.3f", numericRate)
        }
        cell.textLabel?.text = "Graduation Rate: \(value)"
      case 3: // College Career Cell
        if let rate = school.college_career_rate, !rate.isEmpty, let numericRate = Double(rate) {
          value = String(format: "%.3f", numericRate)
        }
        cell.textLabel?.text = "College Career Rate: \(value)"
      default: fatalError("Unknown row in cellForRowAt for section \(indexPath.section)")
    }
    return cell
  }
  
  private func layoutViews() {
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
    ])
  }

}

