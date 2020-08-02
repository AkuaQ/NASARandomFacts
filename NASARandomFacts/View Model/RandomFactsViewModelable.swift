//
//  RandomFactsViewModelable.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

protocol RandomFactsViewModelable {
  func getRandomDate() -> Date
  func convertToString(from date: Date) -> String
  func convertToDate(from str: String) -> Date
  func getRandomsFacts(from date: Date, completionHandler: @escaping(Result<RandomFacts, RandomFactsError>) -> Void)
}

