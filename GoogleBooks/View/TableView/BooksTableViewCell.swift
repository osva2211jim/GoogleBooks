//
//  BooksTableViewCell.swift
//  GoogleBooks
//
//  Created by Osvaldo Arriaga Garduño on 23/08/23.
//

import UIKit

class BooksTableViewCell: UITableViewCell {

    @IBOutlet weak var viewComponents: UIView!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var labelNameBook: UILabel!
    @IBOutlet weak var labelAuthorBook: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewComponents.layer.cornerRadius = 15
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
