//
//  SchoolsTableViewCell.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 2/28/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit

class SchoolsTableViewCell: UITableViewCell {
  static let cellID = "customCell"
  
  var schoolName: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textAlignment = .center
    view.numberOfLines = 0
    view.adjustsFontSizeToFitWidth = true
    return view
  }()
  
  var boroughLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.font = UIFont.italicSystemFont(ofSize: 12)
    view.numberOfLines = 0
    view.adjustsFontSizeToFitWidth = true
    return view
  }()
  
  var addressLabel1: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.font = UIFont.italicSystemFont(ofSize: 12)
    view.textAlignment = .right
    view.numberOfLines = 0
    view.adjustsFontSizeToFitWidth = true
    return view
  }()
  
  var addressLabel2: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.font = UIFont.italicSystemFont(ofSize: 12)
    view.textAlignment = .right
    view.numberOfLines = 0
    view.adjustsFontSizeToFitWidth = true
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    layoutViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layoutViews() {
    addSubview(schoolName)
    addSubview(boroughLabel)
    addSubview(addressLabel1)
    addSubview(addressLabel2)
    
    NSLayoutConstraint.activate([
      schoolName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
      schoolName.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      schoolName.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
      schoolName.bottomAnchor.constraint(equalTo: addressLabel1.topAnchor, constant: -8),
      
      boroughLabel.leftAnchor.constraint(equalTo: schoolName.leftAnchor),
      boroughLabel.bottomAnchor.constraint(equalTo: addressLabel1.bottomAnchor),
      boroughLabel.widthAnchor.constraint(equalTo: schoolName.widthAnchor, multiplier: 1/3),
      addressLabel1.heightAnchor.constraint(equalToConstant: 20),
      
      addressLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
      addressLabel1.bottomAnchor.constraint(equalTo: addressLabel2.topAnchor),
      addressLabel1.widthAnchor.constraint(equalTo: schoolName.widthAnchor, multiplier: 2/3),
      addressLabel1.heightAnchor.constraint(equalToConstant: 20),

      addressLabel2.rightAnchor.constraint(equalTo: addressLabel1.rightAnchor),
      addressLabel2.widthAnchor.constraint(equalTo: addressLabel1.widthAnchor),
      addressLabel2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
    ])
  }
}
