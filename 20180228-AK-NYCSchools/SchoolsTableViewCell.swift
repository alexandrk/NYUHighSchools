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
    view.textAlignment = .left
    view.numberOfLines = 0
    view.adjustsFontSizeToFitWidth = true
    return view
  }()
  
  var addressLabel1: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.font = UIFont.italicSystemFont(ofSize: 12)
    view.textAlignment = .left
    view.numberOfLines = 0
    view.adjustsFontSizeToFitWidth = true
    return view
  }()
  
  var addressLabel2: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.font = UIFont.italicSystemFont(ofSize: 12)
    view.textAlignment = .left
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
    addSubview(addressLabel1)
    addSubview(addressLabel2)
    
    NSLayoutConstraint.activate([
      schoolName.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
      schoolName.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      schoolName.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
      schoolName.bottomAnchor.constraint(equalTo: addressLabel1.topAnchor, constant: -5),
      
      addressLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
      addressLabel1.widthAnchor.constraint(equalTo: widthAnchor),
      addressLabel1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//
//
//      addressLabel2.leftAnchor.constraint(equalTo: addressLabel1.rightAnchor),
//      addressLabel2.topAnchor.constraint(equalTo: addressLabel1.topAnchor),
//      addressLabel2.widthAnchor.constraint(equalTo: addressLabel1.widthAnchor),
    ])
  }
}
