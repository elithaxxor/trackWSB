//
//  FinanceDocumentsViewCell.swift
//  
//
//  Created by a-robota on 6/3/22.
//

import UIKit

class FinanceDocumentsViewCell: UITableViewCell {

//    var FinanceDocsView = FinanceDocumentsViewController

    
    
    var docsView = UITextView()
    var DocsLabel = UILabel()
    let  docs = [docsResults].self



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(DocsLabel)
        addSubview(docsView)

        configureTextView()
        configureTitleLabel()
        setLabelConstraints()
        setLabelConstraints()

    }

    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

    // Passes var from VC
    func set(cellView: FinanceDocs){
        print("[!] Setting View Finance Docs View-Cell")
        let label = "Sample Cell View Label"
        DocsLabel.text = cellView.id
        docsView.text =  cellView.request_id

    }


    func configureTextView() {
        docsView.layer.cornerRadius = 10
        docsView.clipsToBounds = true
    }

    func configureTitleLabel() {
        DocsLabel.numberOfLines = 0
        DocsLabel.adjustsFontSizeToFitWidth = true
    }


    // MARK: Constriants
    func setDocsConstraint() {
        docsView.translatesAutoresizingMaskIntoConstraints
        docsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        docsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive
        docsView.heightAnchor.constraint(equalToConstant: 80).isActive
        docsView.widthAnchor.constraint(equalTo: docsView.heightAnchor, multiplier: 16/9)


    }

    func setLabelConstraints() {
        DocsLabel.translatesAutoresizingMaskIntoConstraints
        DocsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive
        DocsLabel.leadingAnchor.constraint(equalTo: docsView.trailingAnchor, constant: 20).isActive
        DocsLabel.heightAnchor.constraint(equalToConstant: 80).isActive
        DocsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive

    }

//    func setTitleConstraints() {
//        DocsLabel.translatesAutoresizingMaskIntoConstraints
//        DocsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive
//        DocsLabel.leadingAnchor.constraint(equalTo: docsView.trailingAnchor, constant: 20).isActive
//        DocsLabel.heightAnchor.constraint(equalToConstant: 80).isActive
//        DocsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive
//
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }



}
