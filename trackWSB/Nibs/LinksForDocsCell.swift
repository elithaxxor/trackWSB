//
//  LinksForDocsCell.swift
//  Finance_App01
//
//  Created by Adel Al-Aali on 6/26/22.
//

import UIKit

class LinksForDocsCell: UITableViewCell {

    @IBOutlet weak var titleFilingDate: UILabel!
    @IBOutlet weak var titleCompanyName: UILabel! 
    @IBOutlet weak var sourceFilingURL: UILabel!
    @IBOutlet weak var sourceFIlingFileURL: UILabel!
    @IBOutlet weak var cik: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
