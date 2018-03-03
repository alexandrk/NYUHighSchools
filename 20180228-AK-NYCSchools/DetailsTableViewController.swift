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
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    
    navigationItem.title = "School Details"
    navigationController?.navigationBar.isTranslucent = false
    
    // Setup TableView
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    tableView.register(GenericCell.self, forCellReuseIdentifier: GenericCell.cellID)
    tableView.register(MapViewCell.self, forCellReuseIdentifier: MapViewCell.cellID)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    
    layoutViews()
    
    requestSATScores() {
      self.tableView.reloadRows(at: [IndexPath(row: 0, section: 3),
                                IndexPath(row: 1, section: 3),
                                IndexPath(row: 2, section: 3),
                                IndexPath(row: 3, section: 3)], with: UITableViewRowAnimation.automatic)
    }
  }

  private func requestSATScores(completionHandler: @escaping () -> Void) {
    let client = SODAClient(domain: "data.cityofnewyork.us", token: "pMWYN2xWjHGuTWK18ZmHUq3Tj")
    
    // Default Socrata parameters to query the most recent version of the API back end
    let parameters: [String:String] = [
      "$$version": "2.1",
      "$$read_from_nbe": "true"
    ]
    
    let schoolList = client.query(dataset: "f9bf-2cp4", defaultParameters: parameters)
    
    schoolList.filter("dbn='\(school.dbn)'").get { res in
      switch res {
      case .dataset (let data):
        
        do {
          self.satScores = try JSONDecoder().decode([SATScores].self, from: data)
          completionHandler()
        } catch {
          print(error)
        }
        
      case .error (let error):
        
        print("Failure")
        print(error)
        
      }
    }
  }
  
  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }

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


func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell(style: .subtitle, reuseIdentifier: GenericCell.cellID)
  
    // Default cell settings
    cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
    cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.numberOfLines = 0
  
    switch indexPath.section {
      case 0: // Name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = school.school_name
      
      case 1: // Overview
        cell.textLabel?.textAlignment = .justified
        cell.textLabel?.text = school.overview_paragraph
      
      case 2: // Location
        switch indexPath.row {
          case 0: // Map
            let mapCell = MapViewCell(style: .default, reuseIdentifier: MapViewCell.cellID)
            
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
              cell.heightAnchor.constraint(equalToConstant: 0)
            }
          case 1: // Address
            cell.textLabel?.text = school.primary_address_line_1
            cell.detailTextLabel?.text = "\(school.city) \(school.state_code) \(school.zip)"
          case 2: // Phone
            cell.textLabel?.text = "Phone Number:"
            cell.detailTextLabel?.text = "\(school.phone_number)"
          case 3: // Website
            cell.textLabel?.text = "Website:"
            cell.detailTextLabel?.text = "\(school.website ?? "N/A")"
          default: fatalError("Unknown row in cellForRowAt for section \(indexPath.section)")
        }
      case 3: // SAT
        var numberOfTakers = "N/A"
        var criticalReading = "N/A"
        var math = "N/A"
        var writing = "N/A"
        if let satScores = satScores, satScores.count > 0 {
          numberOfTakers = satScores[0].num_of_sat_test_takers ?? "N/A"
          criticalReading = satScores[0].sat_critical_reading_avg_score ?? "N/A"
          math = satScores[0].sat_math_avg_score ?? "N/A"
          writing = satScores[0].sat_writing_avg_score ?? "N/A"
        }
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Number of Takers: \(numberOfTakers)"
        case 1: cell.textLabel?.text = "Critical Reading Avg. Score: \(criticalReading)"
        case 2: cell.textLabel?.text = "Math Avg. Score: \(math)"
        case 3: cell.textLabel?.text = "Writing Avg. Score : \(writing)"
        default: fatalError("Unknown row in cellForRowAt for section \(indexPath.section)")
        }
      case 4: // Stats
        var value = "N/A"
        switch indexPath.row {
        case 0: // Number of students
          cell.textLabel?.text = "Number of Students: \(school.total_students)"
        case 1:
          if let rate = school.attendance_rate, !rate.isEmpty, let numericRate = Double(rate) {
            value = String(format: "%1.2f", numericRate)
          }
          cell.textLabel?.text = "Attendence Rate: \(value)"
        case 2:
          if let rate = school.graduation_rate, !rate.isEmpty, let numericRate = Double(rate) {
            value = String(format: "%.3f", numericRate)
          }
          cell.textLabel?.text = "Graduation Rate: \(value)"
        case 3:
          if let rate = school.college_career_rate, !rate.isEmpty, let numericRate = Double(rate) {
            value = String(format: "%.3f", numericRate)
          }
          cell.textLabel?.text = "College Career Rate: \(value)"
        default: fatalError("Unknown row in cellForRowAt for section \(indexPath.section)")
        }
      default:
        print("finish implementing all sections")
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

class GenericCell: UITableViewCell {
  static let cellID = "genericCell"
}

class MapViewCell: UITableViewCell {
  static let cellID = "mapViewCell"
  
  let mapView: MKMapView = {
    let view = MKMapView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubview(mapView)
    NSLayoutConstraint.activate([
      mapView.centerXAnchor.constraint(equalTo: centerXAnchor),
      mapView.centerYAnchor.constraint(equalTo: centerYAnchor),
      mapView.widthAnchor.constraint(equalTo: widthAnchor),
      mapView.heightAnchor.constraint(equalToConstant: 250),
      mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

