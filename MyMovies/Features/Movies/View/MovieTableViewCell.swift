//
//  MovieTableViewCell.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 17/02/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //*************************************************
    // MARK: - Outlets
    //*************************************************
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
