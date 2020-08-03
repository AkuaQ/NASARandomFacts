//
//  NASAURLComponents.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/08/03.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct NASAURLComponents {
  private static let baseAPIURL: String = "https://api.nasa.gov/planetary/apod?"
  static let personalAPIURLKey = "&api_key=LIOMydhJfp0DvfyfmqfLAvBsgB7I6i8uWZlxPljm"
  static let demoAPIKey = "&api_key=DEMO_KEY"
  static let specificRandomFactsURL = "\(baseAPIURL)date="
}
