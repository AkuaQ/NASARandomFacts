//
//  RandomFacts.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct RandomFacts: Codable {
  var date: String?
  var explanation: String?
  var hdurl: String?
  var mediaType: String?
  var serviceVersion: String?
  var title: String?
  var url: String?
  
  enum CodingKeys: String, CodingKey {
    case date
    case explanation
    case hdurl
    case mediaType = "media_type"
    case serviceVersion = "service_version"
    case title
    case url
  }
}
