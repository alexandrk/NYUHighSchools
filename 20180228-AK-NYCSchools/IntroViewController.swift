//
//  IntroViewController.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 3/1/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

  // MARK: Views Definitions
  // Use scroll view for landscape orientation
  let scrollView: UIScrollView = {
    let view = UIScrollView()
    view.isScrollEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let introLabel: UILabel = {
    let view = UILabel()
    view.text = "This app is created for demonstration purposes. The app utilizes the Open Data provided by the New York City. The data contains iniformation on New York High Schools and their students Average SAT Scores."
    view.font = UIFont.systemFont(ofSize: 13)
    view.textAlignment = .justified
    view.numberOfLines = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let instructionLabel: UILabel = {
    let view = UILabel()
    view.text = "PLEASE SELECT A BOROUGH BELOW:"
    view.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    view.textAlignment = .center
    view.numberOfLines = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Use UIStackViews for flexible layout of borough buttons
  let topStackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.alignment = .fill
    view.distribution = .fillEqually
    view.spacing = 8
    return view
  }()
  
  let bottomStackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.alignment = .fill
    view.distribution = .fillEqually
    view.spacing = 8
    return view
  }()
  
  // Each Borough button passes a value that is stored in the unused
  // 'disabled' state of the button to the next view for API request
  let queensButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "queens"), for: .normal)
    view.setTitle("Queens", for: .normal)
    view.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    view.setTitle("Q", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let manhattanButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "manhattan"), for: .normal)
    view.setTitle("Manhattan", for: .normal)
    view.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    view.setTitle("M", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let bronxButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "bronx"), for: .normal)
    view.setTitle("Bronx", for: .normal)
    view.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    view.setTitle("X", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let brooklynButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "brooklyn"), for: .normal)
    view.setTitle("Brooklyn", for: .normal)
    view.setTitleShadowColor(.black, for: .normal)
    view.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    view.setTitle("K", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let statenIslandButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "statenIsland"), for: .normal)
    view.setTitle("Staten Island", for: .normal)
    view.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    view.setTitle("R", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let outroLabel: UILabel = {
    let view = UILabel()
    view.text = "Note: Latest High School Directory Data is from 2017, whereas latest SAT Scores Data is from 2013."
    view.font = UIFont.systemFont(ofSize: 12)
    view.numberOfLines = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    navigationItem.title = "NYU Schools"
    
    layoutViews()
    
  }

  // MARK: - Other Private Methods
  
  /**
   Event Handler for 'Borough' button click
   - Parameter sender: UIButton object that triggered the event
   */
  @objc private func boroughClicked(sender: UIButton?) {
    let vc = SchoolsViewController()
    vc.boro = sender?.title(for: .disabled)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  /**
   Sets up AutoLayout constraints for all the subView
   - Parameter sender: UIButton object that triggered the event
   */
  private func layoutViews() {
    view.addSubview(scrollView)
    scrollView.addSubview(introLabel)
    scrollView.addSubview(instructionLabel)
    
    scrollView.addSubview(topStackView)
    topStackView.addArrangedSubview(queensButton)
    topStackView.addArrangedSubview(manhattanButton)
    topStackView.addArrangedSubview(bronxButton)

    scrollView.addSubview(bottomStackView)
    bottomStackView.addArrangedSubview(brooklynButton)
    bottomStackView.addArrangedSubview(statenIslandButton)
    
    scrollView.addSubview(outroLabel)
    
    NSLayoutConstraint.activate([
      scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
      scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
      
      introLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      introLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      introLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      
      instructionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      instructionLabel.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20),
      instructionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      
      topStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      topStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
      topStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      
      bottomStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8),
      bottomStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      
      // Equal width|height constrains for one item in each UIStackView,
      // these make sure that all borough buttons are squared
      queensButton.heightAnchor.constraint(equalTo: queensButton.widthAnchor),
      brooklynButton.heightAnchor.constraint(equalTo: brooklynButton.widthAnchor),
      
      outroLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      outroLabel.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 20),
      outroLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      outroLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
  }
  
}
