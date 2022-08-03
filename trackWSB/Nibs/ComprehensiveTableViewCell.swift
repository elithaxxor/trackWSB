//
//  ComprehensiveTableViewCell.swift
//  
//
//  Created by Adel Al-Aali on 6/26/22.
//

import UIKit

class ComprehensiveTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var bodyLabel : UILabel!
    @IBOutlet weak var comprehensive: UILabel!
    @IBOutlet weak var other: UILabel!
    @IBOutlet weak var attributed2parent: UILabel!
    @IBOutlet weak var other2parent: UILabel!
    @IBOutlet weak var loss2noncontrol: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
