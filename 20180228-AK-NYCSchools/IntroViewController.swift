//
//  IntroViewController.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 3/1/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

  let scrollView: UIScrollView = {
    let view = UIScrollView()
    view.isScrollEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let introLabel: UILabel = {
    let view = UILabel()
    view.text = "This app was created for demonstration purposes. The app accesses Open Dataset made available by the state of New York, which contains iniformation on New York county High Schools and students Average SAT Scores. Please selct a borough above to continue."
    view.font = UIFont.systemFont(ofSize: 12)
    view.textAlignment = .justified
    view.numberOfLines = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
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
  
  let queensButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "queens"), for: .normal)
    view.setTitle("Queens", for: .normal)
    view.titleLabel?.shadowColor = .black
    view.setTitle("Q", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let manhattanButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "manhattan"), for: .normal)
    view.setTitle("Manhattan", for: .normal)
    view.setTitle("M", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let bronxButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "bronx"), for: .normal)
    view.setTitle("Bronx", for: .normal)
    view.setTitle("X", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let brooklynButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "brooklyn"), for: .normal)
    view.setTitle("Brooklyn", for: .normal)
    view.setTitle("K", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let statenIslandButton: UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setBackgroundImage(#imageLiteral(resourceName: "statenIsland"), for: .normal)

    view.setTitle("Staten Island", for: .normal)
    view.setTitle("R", for: UIControlState.disabled)
    view.addTarget(self, action: #selector(boroughClicked), for: .touchUpInside)
    return view
  }()
  
  let outroLabel: UILabel = {
    let view = UILabel()
    view.text = "Note: High School Directory Data is from 2017, whereas SAT Scores are from 2013."
    view.font = UIFont.systemFont(ofSize: 12)
    view.numberOfLines = 0
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc private func boroughClicked(sender: UIButton?) {
    let vc = SchoolsViewController()
    vc.boro = sender?.title(for: .disabled)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Boroughs", style: .plain, target: nil, action: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    navigationItem.title = "NYU Schools"
    
    layoutViews()
    
  }

  private func layoutViews() {
    view.addSubview(scrollView)
    scrollView.addSubview(introLabel)
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
      
      topStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      topStackView.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20),
      topStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      
      bottomStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8),
      bottomStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      
      queensButton.heightAnchor.constraint(equalTo: queensButton.widthAnchor),
      brooklynButton.heightAnchor.constraint(equalTo: brooklynButton.widthAnchor),
      
      outroLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      outroLabel.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 20),
      outroLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
      outroLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
  }
  
}
