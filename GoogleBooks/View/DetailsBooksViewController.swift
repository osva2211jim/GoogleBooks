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
    
    func configureLabels(){
        labelId.text = "Id del libro:\n\n\(item.id)"
        labelName.text = "Nombre del libro:\n\n\(item.volumeInfo.title)"
        
        if let description = item.volumeInfo.description, !description.isEmpty {
            labelDescriptionBook.text = "Sinopsis:\n\n\(item.volumeInfo.description!)"
        } else {
            labelDescriptionBook.hide(true, height: 0)
        }
        
        if let publishedDate = item.volumeInfo.publishedDate, !publishedDate.isEmpty {
            labelDatePublished.text = "Fecha de publicación:\n\n\(item.volumeInfo.publishedDate!)"
        } else {
            labelDatePublished.hide(true, height: 0)
        }
        
        if let author = item.volumeInfo.authors?.joined(separator: ","), !author.isEmpty {
            labelAuthor.text = "Autor(es):\n\n\(author)"
        } else {
            labelAuthor.hide(true, height: 0)
        }
    }
    
    func setupView(){
        configureLabels()
        
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
