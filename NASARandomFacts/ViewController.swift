//
//  ViewController.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/07/31.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var randomItems = [RandomFacts](){
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let randomFactRequest = RandomFactsRequest(dateQuery: "2015-09-09")
    randomFactRequest.getSearchResult{result in
      self.randomItems.append(result)
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return randomItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    
    let randomFact = randomItems[indexPath.row]
    cell.textLabel?.text = randomFact.title
    return cell
  }
}

