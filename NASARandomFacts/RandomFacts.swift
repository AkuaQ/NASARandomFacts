//
//  RandomFacts.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct RandomFacts: Decodable {
  var date: String
  var explanation: String
  var hdurl: String?
  var media_type: String
  var service_version: String
  var title: String
  var url: String?
}
