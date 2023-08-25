//
//  DetailsBooksViewController.swift
//  GoogleBooks
//
//  Created by Osvaldo Arriaga Garduño on 24/08/23.
//

import UIKit
import SDWebImage

class DetailsBooksViewController: UIViewController {
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelDatePublished: UILabel!
    @IBOutlet weak var labelDescriptionBook: UILabel!
    
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("esto traigo", item)
        configureUI()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        imageBook.layer.cornerRadius = 10
    }
    
    func setupView(){
        labelId.text = "Id del libro:\n\n\(item.id)"
        labelName.text = "Nombre del libro:\n\n\(item.volumeInfo.title)"
        let author = item.volumeInfo.authors?.joined(separator: ",")
        
        if item.volumeInfo.description != "" && item.volumeInfo.description != nil {
            labelDescriptionBook.text = "Sinopsis:\n\n\(item.volumeInfo.description!)"
        } else {
            labelDescriptionBook.hide(true, height: 0)
        }
        if item.volumeInfo.publishedDate != "" && item.volumeInfo.publishedDate != nil {
            labelDatePublished.text = "Fecha de publicación:\n\n\(item.volumeInfo.publishedDate!)"
        } else {
            labelDatePublished.hide(true, height: 0)
        }
        if author != "" && author != nil {
            labelAuthor.text = "Autor(es):\n\n\(author!)"
        } else {
            labelAuthor.hide(true, height: 0)
        }
        
        if let imageLinks = item.volumeInfo.imageLinks, let thumbnailURLString = imageLinks.thumbnail, let thumbnailURL = URL(string: thumbnailURLString.replacingOccurrences(of: "http", with: "https")) {
            print("esto es mi image", thumbnailURL)
            imageBook?.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "default_image"))
        } else {
            imageBook?.image = UIImage(named: "default_image")
        }
    }
}

extension UIView {
    func hide(_ isHidden: Bool, height: CGFloat) {
        if isHidden {
            self.alpha = 0
        } else {
            self.alpha = 1
        }
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
