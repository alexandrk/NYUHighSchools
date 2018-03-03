//
//  Networking.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 3/3/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import Foundation
class Networking {
  
  /**
   Get list of high schools from Sacrata API
   - Parameter boro: borough abbreviation for narrower results list
   - Parameter completionHandler: returns the results of the API call back
  */
  static func requestSchools(boro: String, completionHandler: @escaping ([School]?, Error?) -> Void) {
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
          let schools = try JSONDecoder().decode([School].self, from: data)
          completionHandler(schools, nil)
        } catch {
          completionHandler(nil, error)
        }
        
      case .error (let error):
        completionHandler(nil, error)
      }
    }
  }
  
  /**
   Get SAT Scores for a particular school ID
   - Parameter dbn: SchoolID in the Sacrata DB for New York HS
   - Parameter completionHandler: returns the results of the API call back
   */
  static func requestSATScores(schoolID dbn: String, completionHandler: @escaping ([SATScores]?, Error?) -> Void) {
    let client = SODAClient(domain: "data.cityofnewyork.us", token: "pMWYN2xWjHGuTWK18ZmHUq3Tj")
    
    // Default Socrata parameters to query the most recent version of the API back end
    let parameters: [String:String] = [
      "$$version": "2.1",
      "$$read_from_nbe": "true"
    ]
    
    let schoolList = client.query(dataset: "f9bf-2cp4", defaultParameters: parameters)
    
    schoolList.filter("dbn='\(dbn)'").get { res in
      switch res {
      case .dataset (let data):
        
        do {
          let satScores = try JSONDecoder().decode([SATScores].self, from: data)
          completionHandler(satScores, nil)
        } catch {
          completionHandler(nil, error)
        }
        
      case .error (let error):
        completionHandler(nil, error)
      }
    }
  }
}
