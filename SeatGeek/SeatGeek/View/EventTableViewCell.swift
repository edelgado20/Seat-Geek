//
//  EventTableViewCell.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/24/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var heartImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var eventViewModel: EventViewModel! {
        didSet {
            if eventViewModel.isFavorite {
                heartImgView.isHidden = false
            } else {
                heartImgView.isHidden = true
            }
            nameLabel.text = eventViewModel.name
            locationLabel.text = eventViewModel.location
            dateLabel.text = eventViewModel.utcToLocal(convert: eventViewModel.date, to: "EEEE, dd MMM yyyy\nhh:mm a")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
