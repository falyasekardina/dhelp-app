//
//  TableViewCell.swift
//  DhelpApp
//
//  Created by Graciela gabrielle Angeline on 09/04/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    static let identifier = "detailHistoryCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
        label.frame = CGRect(x: 15, y:0, width: contentView.frame.size.width - 15, height: contentView.frame.size.height)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with model:DetailHistory){
        label.text = model.item
    }
}
