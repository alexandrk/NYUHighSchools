//
//  School.swift
//  20180228-AK-NYCSchools
//
//  Created by Alexander on 2/28/18.
//  Copyright © 2018 Dictality. All rights reserved.
//

import Foundation

struct School: Decodable {
  let dbn: String
  let school_name: String
  let overview_paragraph: String
  
  let borough: String?
  let neighborhood: String
  let primary_address_line_1: String
  let city: String
  let state_code: String
  let zip: String
  let phone_number: String
  let website: String?
  let latitude: String?
  let longitude: String?
  
  let subway: String
  let language_classes: String?
  let attendance_rate: String
  let graduation_rate: String?
  let college_career_rate: String?
  let total_students: String
}

struct SATScores: Decodable {
  let dbn: String
  let school_name: String
  
  let num_of_sat_test_takers: String?
  let sat_critical_reading_avg_score: String?
  let sat_math_avg_score: String?
  let sat_writing_avg_score: String?
  
}
