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
  @IBOutlet weak var searchBar: UISearchBar!
  lazy var viewModel: RandomFactsViewModel = {
      return RandomFactsViewModel(view: self)
  }()
  var randomFactsItems = [RandomFacts](){
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    viewModel.getWeeklyRandomsFacts(from: viewModel.getRandomDate()) {result in
      self.randomFactsItems = result
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return randomFactsItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    
    let randomFact = randomFactsItems[indexPath.row]
    cell.textLabel?.text = randomFact.title
    return cell
  }
}

extension ViewController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchBarText = searchBar.text {
      viewModel.getWeeklyRandomsFacts(from: searchBarText) {result in
        self.randomFactsItems = result
      }
    }
  }
}

protocol Viewable: class {}
extension ViewController: Viewable {}
