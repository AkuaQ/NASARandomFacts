//
//  RandomFactsRepositorable.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/08/03.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

protocol RandomFactsRepositorable {
  func getRandomFacts(from date: Date, completionHandler: @escaping(Result<RandomFacts, RandomFactsError>) -> Void)
}
