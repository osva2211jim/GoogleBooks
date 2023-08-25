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
    @IBOutlet weak var tableViewBooks: UITableView!
    
    var model: ModelBooks!
    var isLoadingData = false
    let pageSize = 10
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
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
                    self.tableViewBooks.reloadData()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func pageData() {
        let searchQuery = searchBar.text?.replacing(" ", with: "_")
        guard let search = searchQuery else { return }
        let startIndex = model.items.count // Último índice + 1
        URLSession.fetchBooksPage(withQuery: search, startIndex: startIndex, pageSize: pageSize) { result in
            switch result {
            case .success(let response):
                print("esta es mi respuesta del modelo", response)
                self.model.items.append(contentsOf: response.items)
                DispatchQueue.main.async {
                    self.tableViewBooks.reloadData()
                    self.isLoadingData = false // Restablece el indicador de carga
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
                self.isLoadingData = false
            }
        }
    }
    
    func configureDelegate(){
        tableViewBooks.dataSource = self
        tableViewBooks.delegate = self
        searchBar.delegate = self
        tableViewBooks.register(UINib(nibName: "BooksTableViewCell", bundle: nil), forCellReuseIdentifier: "BooksTableViewCell")
    }
    
    func configureUI(){
        labelTitle.text = "Google Books"
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
        cell.labelAuthorBook.text = autors != "" ? autors : "Autor desconocido"
        if let imageLinks = model.items[indexPath.row].volumeInfo.imageLinks, let thumbnailURLString = imageLinks.thumbnail, let thumbnailURL = URL(string: thumbnailURLString.replacingOccurrences(of: "http", with: "https")) {
            print("esto es mi image", thumbnailURL)
            cell.imageBook?.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "default_image"))
        } else {
            cell.imageBook?.image = UIImage(named: "default_image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = model.items[indexPath.row]
        let vc = DetailsBooksViewController()
        vc.item = selectedItem
        self.present(vc, animated: true)
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("entre")
        fetchData()
    }
}

extension BooksViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height
        
        if offsetY > contentHeight - visibleHeight {
            print("llegue al final debo actualiar y evito consumir repetidas veces")
            if !isLoadingData {
                pageData()
                isLoadingData = true
            }
        }
    }
}
