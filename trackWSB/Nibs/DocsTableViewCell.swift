//
//  Docs2TableViewCell.swift
//  Finance_App01
//
//  Created by Adel Al-Aali on 6/26/22.
//

import UIKit

import UIKit
struct newDoc {
    let title : String
}
extension Notification.Name {
    
}
class DocsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var bodyLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       // configure(with: docsCellResults)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func configure(with : docsResults){
        print("")
       

    }

}
