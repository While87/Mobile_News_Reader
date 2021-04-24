//
//  NewsViewController.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 16.04.2021.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    let realm = try! Realm()
    var newsItems: Results<NewsRM>?
    
    let cellId = "NewsTableViewCell"
    
    var newsManager = ChannelAndNewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsItems = realm.objects(NewsRM.self)
        
        newsManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //регистрируем Nib
        tableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
   
        loadNewsItems()
    }
    
    func loadNewsItems() {
        
        for id in realm.objects(ChannelRM.self).filter("subscribe == true") {
            newsManager.fetchNews(channelSource: id.id)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems?.count ?? 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsTableViewCell
        
        //супер кривой NewsAPI может иметь null или "" (пустой) заголовок новости и description
        //Особенно отжигают Арабские новости, они могут не иметь ни того ни дрогого, только название
        if newsItems?[indexPath.row].title != nil || newsItems?[indexPath.row].title != "" {
            cell.newsTitle.text = newsItems?[indexPath.row].title
        } else if newsItems?[indexPath.row].descript != nil || newsItems?[indexPath.row].descript != ""  {
            cell.newsTitle.text = newsItems?[indexPath.row].descript
        }
        else {
            cell.newsTitle.text = "No news title" //Увы...
        }
        
        cell.newsContent.text = newsItems?[indexPath.row].content ?? ""
        cell.newsImage.image = UIImage(data: (newsItems?[indexPath.row].image)!)

        return cell
    }    
}

extension NewsViewController: ChannelAndNewsManagerDelegate {
    func didUpdateData(data: Any?) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWhithError(_ error: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Упсс...", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style:  .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    
}
