//
//  SearchViewController.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 15.04.2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //let cellId = "NewsTableViewCell"
    let cellId = "ChannelTableViewCell"
    
    var searchItems :NewsData?
    
    var newsManager = ChannelAndNewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsManager.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    
        //регистрируем Nib
        tableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != "") {
            newsManager.searchNews(searchRequest: searchBar.text!)}
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChannelTableViewCell
    
        cell.channelTitle.text = searchItems?.articles[indexPath.row].title
        cell.channelDescription.text = searchItems?.articles[indexPath.row].content
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsTableViewCell
//        cell.newsTitle.text = searchItems?.articles[indexPath.row].title
//        cell.newsContent.text = searchItems?.articles[indexPath.row].content
//
        //если ссылка на изображение не пустая, пробуем загрузить изображение
//        if (searchItems?.articles[indexPath.row].urlToImage) != nil {
//            var image = UIImage()
//            do {
//            let imageData = try Data(contentsOf: URL(string: (searchItems?.articles[indexPath.row].urlToImage!)!)!)
//                image = UIImage(data: imageData)!
//            } catch {}
//            cell.newsImage.image = image
//        }
        
        
        return cell
    
    }
}

extension SearchViewController: ChannelAndNewsManagerDelegate {
    func didUpdateData(data: Any?) {
        
        searchItems = data as! NewsData?
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWhithError(_ error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Упсс...", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style:  .default, handler: nil))
            self.present(alert, animated: true)
        }    }
    
    
}
