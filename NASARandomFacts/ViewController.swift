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
  @IBOutlet weak var inputDateTextField: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  var datePicker: UIDatePicker?
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
    tableView.rowHeight = 208
    viewModel.getRandomsFacts(from:  viewModel.getRandomDate()){ result in
      switch result {
      case .success(let randomFact):
        self.randomFactsItems.append(randomFact)
      case .failure( _):
        break
      }
    }
    
    setUpDatePicker()
    inputDateTextField.inputView = datePicker
  }
  
  @IBAction func searchButtonTapped(_ sender: UIButton) {
    let dateChosen = inputDateTextField.text
    
    if inputDateTextField.text == "" {
      errorLabel.text = "Choose a date below"
      errorLabel.isHidden = false
    } else if let dateChosen = dateChosen {
      viewModel.getRandomsFacts(from: viewModel.convertToDate(from: dateChosen)) {result in
        switch result {
        case .success(let randomFact):
          self.randomFactsItems.insert(randomFact, at: 0)
        case .failure( _):
          break
        }
      }
    }
  }
  
  private func setUpDatePicker() {
    datePicker = UIDatePicker()
    datePicker?.minimumDate =  viewModel.getMinDate()
    datePicker?.datePickerMode = .date
    datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    datePicker?.maximumDate = viewModel.getMaxDate()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func dateChanged(datePicker: UIDatePicker) {
    inputDateTextField.text = viewModel.convertToString(from: datePicker.date)
  }
  
  @objc private func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
    guard let datePicker = datePicker else {
      return
    }
    inputDateTextField.text = viewModel.convertToString(from: datePicker.date)
    view.endEditing(true)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return randomFactsItems.count
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      randomFactsItems.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.randomFactsTableCell, for: indexPath) as?
      RandomFactsTableViewCell else {
        let cell = UITableViewCell(style: .default, reuseIdentifier: ViewConstants.randomFactsTableCell)
        return cell
    }
    
    let randomFact = randomFactsItems[indexPath.row]
    cell.titleLabel.text = randomFact.title
    cell.explanationLabel.text = randomFact.explanation
    cell.dateLabel.text = randomFact.date
    
    //Fetch Image from URL
    let imageURL = randomFact.url
    let imageHDURL = randomFact.hdurl
    
    if randomFact.mediaType == "image" {
      if let imageURL = imageURL {
        guard let url = URL(string: imageURL) else {fatalError("Unable to connect to server")}
        cell.pictureImageView.downloadImage(from: url)
      } else if let imageHDURL = imageHDURL {
        guard let url = URL(string: imageHDURL) else {fatalError("Unable to connect to server")}
        cell.pictureImageView.downloadImage(from: url)
        
      } else {
        cell.pictureImageView.image = UIImage(named: "noImage")
      }
    } else {
      cell.pictureImageView.image = UIImage(named: "noImage")
    }
    return cell
  }
}

extension UIImageView {
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  func downloadImage(from url: URL) {
    getData(from: url) {data, _, error in
      guard let data = data, error == nil else {return}
      DispatchQueue.main.async {
        self.image = UIImage(data: data)
      }
    }
  }
}

protocol Viewable: class {
  func displayMessage(of error: RandomFactsError)
  func dismissErrorMessage()
}
extension ViewController: Viewable {
  func displayMessage(of error: RandomFactsError) {
    errorLabel.isHidden = false
  }
  
  func dismissErrorMessage() {
    errorLabel.isHidden = true
  }
}
