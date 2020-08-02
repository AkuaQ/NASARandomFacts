//
//  RandomFactsRepo.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct RandomFactsRepo {
  let defaultNasaSearchSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?
  
  func getRandomFacts(from date: Date, completionHandler: @escaping(Result<RandomFacts, RandomFactsError>) -> Void) {
    dataTask?.cancel()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    let resourceSearchStr = "https://api.nasa.gov/planetary/apod?date=" + formatter.string(from: date) + "&api_key=DEMO_KEY"
    guard let resourceURL = URL(string: resourceSearchStr) else {fatalError("Cannot connect right now")}
    
    let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, response, error in
      
      if error != nil {
        completionHandler(.failure(.noDataAvailable))
      } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        do {
          let infoList = try JSONDecoder().decode(RandomFacts.self, from: data)
          completionHandler(.success(infoList))
        } catch {
          completionHandler(.failure(.canNotProcessData))
        }
      }
    }
    
    dataTask.resume()
  }
}
