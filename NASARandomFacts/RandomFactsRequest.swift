//
//  RandomFactsRequest.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct RandomFactsRequest {
  let dateQuery: String
  let defaultNasaSearchSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?
  
  func getSearchResult(completionHandler: @escaping(RandomFacts) -> Void) {
    dataTask?.cancel()
    
    let resourseSearchStr = "https://api.nasa.gov/planetary/apod?date=" + dateQuery + "&api_key=DEMO_KEY"
    guard let resourceURL = URL(string: resourseSearchStr) else {fatalError("Cannot connect right now")}
    
    let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, response, error in
      
      if let error = error {
        print(error.localizedDescription)
      } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        do {
          let infoList = try JSONDecoder().decode(RandomFacts.self, from: data)
          
          completionHandler(infoList)
        } catch let error {
          print(error)
        }
      }
    }
    
    dataTask.resume()
  }
  
  public init(dateQuery: String) {
    self.dateQuery = dateQuery
  }
}
