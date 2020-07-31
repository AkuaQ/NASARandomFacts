//
//  RandomFactsViewModelable.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

protocol RandomFactsViewModelable {
  func getRandomDate() -> String
  func getWeeklyRandomsFacts(from date: String, completionHandler: @escaping([RandomFacts]) -> Void)
}

