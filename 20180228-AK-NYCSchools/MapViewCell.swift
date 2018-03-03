//
//  MapViewCell.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 3/3/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import UIKit
import MapKit

class MapViewCell: UITableViewCell {
  static let cellIdentifier = "mapViewCell"
  
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
