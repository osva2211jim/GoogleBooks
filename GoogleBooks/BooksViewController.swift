//
//  BooksViewController.swift
//  GoogleBooks
//
//  Created by Osvaldo Arriaga Garduño on 22/08/23.
//

import UIKit
import SDWebImage

class BooksViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var tableViewBooks: UITableView!
    
    var model: ModelBooks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        let searchQuery = searchBar.text?.replacing(" ", with: "_")
        guard let search = searchQuery else {return}
        URLSession.fetchBooks(withQuery: search) { result in
            switch result {
            case .success(let response):
                print("esta es mi respueta de tipo del modelo", response)
                self.model = response
                DispatchQueue.main.sync {
                    self.hideComponents(flag: false)
                    self.tableViewBooks.reloadData()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func configureTableView(){
        tableViewBooks.dataSource = self
        tableViewBooks.delegate = self
        searchBar.delegate = self
        tableViewBooks.register(UINib(nibName: "BooksTableViewCell", bundle: nil), forCellReuseIdentifier: "BooksTableViewCell")
    }
    
    func configureUI(){
        labelTitle.text = "Google Books"
        hideComponents(flag: true)
    }
    
    func hideComponents(flag: Bool){
        if flag == false {
            tableViewBooks.isHidden = false
            buttonMore.isHidden = false
        } else {
            tableViewBooks.isHidden = true
            buttonMore.isHidden = true
        }
    }
    @IBAction func actionButtonShowAll(_ sender: Any) {
        
    }
    
}

extension BooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model == nil {
            return 0
        } else {
            return model.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableViewCell", for: indexPath) as! BooksTableViewCell
        cell.labelNameBook.text = model.items[indexPath.row].volumeInfo.title
        let autors = model.items[indexPath.row].volumeInfo.authors?.joined(separator: ",")
        cell.labelAuthorBook.text = autors != "" ? autors : "Autor no registrado"
        if let imageLinks = model.items[indexPath.row].volumeInfo.imageLinks, let thumbnailURLString = imageLinks.thumbnail, let thumbnailURL = URL(string: thumbnailURLString.replacingOccurrences(of: "http", with: "https")) {
            print("esto es mi image", thumbnailURL)
            cell.imageBook?.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "default_image"))
        } else {
            cell.imageBook?.image = UIImage(named: "default_image")
        }
        return cell
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("entre")
        fetchData()
    }
}
