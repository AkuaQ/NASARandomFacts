//
//  RandomFactsViewModel.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import Foundation

struct RandomFactsViewModel: RandomFactsViewModelable {
  let calendar = Calendar.current
  weak var view: Viewable?
  
  init(view: Viewable) {
    self.view = view
  }
  
  //Calculates number of days in month
  private func getMonthNumOfDays(with year: Int, and month: Int) -> Int {
    let dateComponents = DateComponents(year: year, month: month)
    
    let date = calendar.date(from: dateComponents) ?? Date()
    let rangeOfDays = calendar.range(of: .day, in: .month, for: date)
    let numDays = rangeOfDays?.count ?? 30
    return numDays
  }
  
  //Formats date days
  private func formatDays(with day: Int) -> String {
    if day < 10 {
      return "0\(day)"
    } else {
      return "\(day)"
    }
  }
  
  //Formats date months
  private func formatMonths(with month: Int) -> String {
    if month < 10 {
      return "0\(month)"
    } else {
      return "\(month)"
    }
  }
  
  func getRandomDate() -> String {
    /*Lowest year in database is 1995 & highest year is current year */
    let lowestYear = 1995
    let currentDate = Date()
    let highestYear = calendar.component(.year, from: currentDate)
    let randomYear = Int.random(in: lowestYear...highestYear)
    
    /* Lowest month in lowest year is June & highest month in highest year is current month */
    var randomMonth: Int
    let lowestMonthInLowestYear = 6
    let highestMonthInHighestYear = calendar.component(.month, from: currentDate)
    if randomYear == lowestYear {
      randomMonth = Int.random(in: lowestMonthInLowestYear...12)
    } else if randomYear == highestYear {
      randomMonth = Int.random(in: 1...highestMonthInHighestYear)
    } else {
      randomMonth = Int.random(in: 1...12)
    }
    
    /* Lowest day in lowest year and month is 16 & highest day in highest year and month is current day */
    var randomDay: Int
    let lowestDayInLowestYearAndMonth = 16
    let highestDayInHighestYearAndMonth = calendar.component(.day, from: currentDate)
    //Calculate number of days in month
    let endDay = getMonthNumOfDays(with: randomYear, and: randomMonth)
    if randomMonth == lowestMonthInLowestYear && randomYear == lowestYear {
      randomDay = Int.random(in: lowestDayInLowestYearAndMonth...endDay)
    } else if randomMonth == highestMonthInHighestYear && randomYear == highestYear {
      randomDay = Int.random(in: 1...highestDayInHighestYearAndMonth)
    } else {
      randomDay = Int.random(in: 1...endDay)
    }
    
    let randomDate = "\(randomYear)-\(formatMonths(with: randomMonth))-\(formatDays(with: randomDay))"
    return randomDate
  }
  
  func getWeeklyRandomsFacts(from date: String, completionHandler: @escaping([RandomFacts]) -> Void) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let convertedDate = formatter.date(from: date) ?? Date()
    let indexOfWeekDay = calendar.component(.weekday, from: convertedDate)
    var dateComponent = DateComponents()
    var daysToAdd = 1
    var listOfFacts = [RandomFacts]()
    
    /* Get weekly list of random facts */
    while daysToAdd < 8 {
      dateComponent.day = daysToAdd - (indexOfWeekDay - 1)
      let weekDayDate = calendar.date(byAdding: dateComponent, to: convertedDate)
      let randomFactRequest = RandomFactsRequest(dateQuery: formatter.string(from: weekDayDate ?? Date()))
      randomFactRequest.getSearchResult{result in
        listOfFacts.append(result)
        completionHandler(listOfFacts)
      }
      daysToAdd = daysToAdd + 1
    }
  }
}
