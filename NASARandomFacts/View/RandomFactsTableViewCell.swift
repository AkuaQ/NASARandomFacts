//
//  RandomFactsTableViewCell.swift
//  NASARandomFacts
//
//  Created by Akua Afrane-Okese on 2020/08/01.
//  Copyright © 2020 Akua Afrane-Okese. All rights reserved.
//

import UIKit

class RandomFactsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var pictureImageView: UIImageView!
  @IBOutlet weak var explanationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
