//
//  DetailsViewController.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 3/1/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

  // School ID in the Sacrata Dataset
  var school: School?
  private var satScores: [SATScores]?
  
  let contentView: UIScrollView = {
    let view = UIScrollView()
    view.isScrollEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let overviewLabel: UITextView = {
    let view = UITextView()
    view.isUserInteractionEnabled = false
    view.isScrollEnabled = false
    view.isSelectable = false
    view.font = UIFont.systemFont(ofSize: 12)
    view.textAlignment = .justified
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.cornerRadius = 5
    view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let addressLabel: UITextView = {
    let view = UITextView()
    view.isUserInteractionEnabled = false
    view.isScrollEnabled = false
    view.isSelectable = false
    view.font = UIFont.systemFont(ofSize: 12)
    view.textAlignment = .justified
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.cornerRadius = 5
    view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let satScoresLabel: UITextView = {
    let view = UITextView()
    view.isUserInteractionEnabled = false
    view.isScrollEnabled = false
    view.isSelectable = false
    view.font = UIFont.systemFont(ofSize: 12)
    view.textAlignment = .justified
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.cornerRadius = 5
    view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let statsLabel: UITextView = {
    let view = UITextView()
    view.isUserInteractionEnabled = false
    view.isScrollEnabled = false
    view.isSelectable = false
    view.font = UIFont.systemFont(ofSize: 12)
    view.textAlignment = .justified
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.cornerRadius = 5
    view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let mapView: MKMapView = {
    let view = MKMapView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = school?.school_name
    view.backgroundColor = .white
    layoutViews()
    
    if let latString = school?.latitude, let longString = school?.longitude,
      let latitude = Double(latString), let longitude = Double(longString){
      let centerLocation = CLLocationCoordinate2DMake(latitude, longitude)
      let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      let mapRegion = MKCoordinateRegion(center: centerLocation, span: mapSpan)
      let mapPin = MKPointAnnotation()
      mapPin.coordinate = centerLocation
      mapView.addAnnotation(mapPin)
      mapView.setRegion(mapRegion, animated: true)
    }
    
    requestSATScores() {
      self.populateViews()
    }
    
  }
  
  // MARK: OTHER
  private func requestSATScores(completionHandler: @escaping () -> Void) {
    
    guard let school = self.school else {
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
    
    let schoolList = client.query(dataset: "f9bf-2cp4", defaultParameters: parameters)
    
    schoolList.filter("dbn='\(school.dbn)'").get { res in
      switch res {
      case .dataset (let data):
        
        do {
          self.satScores = try JSONDecoder().decode([SATScores].self, from: data)
          completionHandler()
          //self.tableView.reloadData()
        } catch {
          print(error)
        }
        
      case .error (let error):
        
        print("Failure")
        print(error)
        
      }
    }
  }
  
  private func populateViews() {
    guard let school = school else {
      print("Error: now School ID passed to the View Controller")
      return
    }
    overviewLabel.text = "OVERVIEW:\n\(school.overview_paragraph)"
    addressLabel.text = "ADDRESS:\n\(school.primary_address_line_1)\n\(school.city) \(school.state_code) \(school.zip)\nPhone Number: \(school.phone_number)\nWebsite: \(school.website ?? "N/A")"
    
    statsLabel.text = "STATS:\nNumber of Students: \(school.total_students)\nAttendence Rate: \(school.attendance_rate)\nGraduation Rate: \(school.graduation_rate ?? "N/A")\nCollege Career Rate: \(school.college_career_rate ?? "N/A")"
    
    if let satScores = satScores, satScores.count > 0{
      satScoresLabel.text = "SAT SCORES:\nNum of SAT Test Takers: \(satScores[0].num_of_sat_test_takers ?? "N/A")\nSAT Critical Reading Avg. Score: \(satScores[0].sat_critical_reading_avg_score ?? "N/A")\nSAT Math Avg. Score: \(satScores[0].sat_math_avg_score ?? "N/A")\nSAT Writing Avg. Score: \(satScores[0].sat_writing_avg_score ?? "N/A")"
    }
    else {
      satScoresLabel.text = "No Data Found for SAT Scores."
    }
  }
  
  private func layoutViews() {
    view.addSubview(contentView)
    contentView.addSubview(overviewLabel)
    contentView.addSubview(mapView)
    contentView.addSubview(addressLabel)
    contentView.addSubview(satScoresLabel)
    contentView.addSubview(statsLabel)
    
    NSLayoutConstraint.activate([
      contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      contentView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
      
      overviewLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      overviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      overviewLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
      
      mapView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      mapView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
      mapView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
      mapView.heightAnchor.constraint(equalToConstant: 200),
      
      addressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      addressLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),

      satScoresLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      satScoresLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
      satScoresLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),

      statsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      statsLabel.topAnchor.constraint(equalTo: satScoresLabel.bottomAnchor, constant: 8),
      statsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
      statsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
    ])
    
    var addressLabelConstraint = addressLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8)
    addressLabelConstraint.priority = UILayoutPriority(rawValue: 999)
    addressLabelConstraint.isActive = true
    
    addressLabelConstraint = addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8)
    addressLabelConstraint.isActive = true
  }
  
}
