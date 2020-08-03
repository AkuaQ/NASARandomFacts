//
//  RandomFactsViewModel.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct RandomFactsViewModel: RandomFactsViewModelable {
  private let calendar = Calendar.current
  private let formatter = DateFormatter()
  weak var view: Viewable?
  let maxDate: Date
  let minDate : Date
  
  init(view: Viewable) {
    self.view = view
    self.maxDate = Date()
    formatter.dateFormat = "yyyy-MM-dd"
    self.minDate = formatter.date(from: "1995-06-16") ?? Date()
  }
  
  /**
   Gets maximum/ highest date (the current date) that can be searched for
   - Returns: current date
   */
  func getMaxDate() -> Date {
    return maxDate
  }
  
  /**
   Gets miniimum/ lowest date (16 June 1995) that can be searched for
   - Returns: lowest date
   */
  func getMinDate() -> Date {
    return minDate
  }
  
  /**
   Calculates number of days in month
   - Returns: number of days in month
   */
  private func getNumberOfDays(in month: Int, for year: Int) -> Int {
    let dateComponents = DateComponents(year: year, month: month)
    
    let date = calendar.date(from: dateComponents) ?? Date()
    let rangeOfDays = calendar.range(of: .day, in: .month, for: date)
    let defaultDaysInMonth = 30
    let numDays = rangeOfDays?.count ?? defaultDaysInMonth
    return numDays
  }
  
  /**
   Calculates a random year. The random year holds a boundary restriction of the lowest year in database being 1995 & highest year being current year
   - Returns: a random year of type Int
   */
  private func getRandomYear() -> Int {
    let lowestYear = calendar.component(.year, from: getMinDate())
    let highestYear = calendar.component(.year, from: getMaxDate())
    let randomYear = Int.random(in: lowestYear...highestYear)
    return randomYear
  }
  
  /**
   Calculates a random month. The random month holds a boundary restriction of the lowest month in lowest year being June & the highest month in highest year being current month
   - Returns: a random month of type Int
   */
  private func getRandomMonth(in randomYear: Int) -> Int {
    let lowestYear = calendar.component(.year, from: getMinDate())
    let highestYear = calendar.component(.year, from: getMaxDate())
    var randomMonth: Int
    let lowestMonthInLowestYear = 6
    let highestMonthInHighestYear = calendar.component(.month, from: getMaxDate())
    if randomYear == lowestYear {
      randomMonth = Int.random(in: lowestMonthInLowestYear...12)
    } else if randomYear == highestYear {
      randomMonth = Int.random(in: 1...highestMonthInHighestYear)
    } else {
      randomMonth = Int.random(in: 1...12)
    }
    return randomMonth
  }
  
  /**
   Calculates a random day. The random day holds a boundary restriction of the lowest day in lowest year and month being 16 & highest day in highest year and month being current day
   - Returns: a random day of Int
   */
  private func getRandomDay(in randomMonth: Int, and randomYear: Int) -> Int {
    let lowestMonthInLowestYear = 6
    let highestMonthInHighestYear = calendar.component(.month, from: getMaxDate())
    let lowestYear = calendar.component(.year, from: getMinDate())
    let highestYear = calendar.component(.year, from: getMaxDate())
    var randomDay: Int
    let lowestDayInLowestYearAndMonth = 16
    let highestDayInHighestYearAndMonth = calendar.component(.day, from: getMaxDate())
    
    //Calculate number of days in month
    let endDay = getNumberOfDays(in: randomMonth, for: randomYear)
    if randomMonth == lowestMonthInLowestYear && randomYear == lowestYear {
      randomDay = Int.random(in: lowestDayInLowestYearAndMonth...endDay)
    } else if randomMonth == highestMonthInHighestYear && randomYear == highestYear {
      randomDay = Int.random(in: 1...highestDayInHighestYearAndMonth)
    } else {
      randomDay = Int.random(in: 1...endDay)
    }
    return randomDay
  }
  
  /**
   Gets the random date
   - Returns: a random date of type Date
   */
  func getRandomDate() -> Date {
    let randomYear = getRandomYear()
    let randomMonth = getRandomMonth(in: randomYear)
    let randomDay = getRandomDay(in: randomMonth, and: randomYear)
    let randomDate = DateComponents(year: randomYear, month: randomMonth, day: randomDay)
    return calendar.date(from: randomDate) ?? Date()
  }
  
  /**
   Converts a date to a string
   - Returns: A string in the date format ("yyyy-MM-dd")
   */
  func convertToString(from date: Date) -> String {
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
  
  /**
   Converts a string to a date
   - Returns: A date necessary for API calls
   */
  func convertToDate(from str: String) -> Date {
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: str) ?? Date()
  }
  
  /**
   Gets a random fact from an API call
   */
  func getRandomsFacts(from date: Date, completionHandler: @escaping(Result<RandomFacts, RandomFactsError>) -> Void) {
    formatter.dateFormat = "yyyy-MM-dd"
    let randomFactRequest = RandomFactsRepo()
    randomFactRequest.getRandomFacts(from: date){result in 
      switch result {
      case .success(let randomFacts):
        DispatchQueue.main.async {
          self.view?.dismissErrorMessage()
        }
        completionHandler(.success(randomFacts))
        break
      case .failure(let error):
        DispatchQueue.main.async {
          self.view?.displayMessage(of: error)
        }
        completionHandler(.failure(error))
        break
      }
    }
  }
}
