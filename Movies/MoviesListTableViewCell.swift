//
//  MoviesListTableViewCell.swift
//  Movies
//
//  Created by Nikrad Mahdi on 9/14/15.
//  Copyright © 2015 Nikrad. All rights reserved.
//

import UIKit

class MoviesListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = ""
    synopsisLabel.text = ""
    posterImage.image = nil
  }

}
