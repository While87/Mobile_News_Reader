//
//  FavoriteViewController.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 15.04.2021.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var channelItems: Results<ChannelRM>?
    
    let cellId = "ChannelTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelItems = realm.objects(ChannelRM.self).filter("subscribe == true")
        tableView.delegate = self
        tableView.dataSource = self
        
        //регистрируем Nib
        tableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    //Перезагружаем таблицу, что бы при переходе по tabBar иметь свежие данные в случае изменения каких либо элементов
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return channelItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChannelTableViewCell
        
        
        cell.channelTitle.text = channelItems?[indexPath.row].title ?? "No favorite channels"
        cell.channelDescription.text = channelItems?[indexPath.row].descript ?? ""
        cell.isFavorite = channelItems?[indexPath.row].subscribe ?? false
        
        cell.favoriteButton.addTarget(self, action: #selector(favoritePressed) , for: .touchUpInside)
        cell.accessoryView = cell.favoriteButton

        return cell
    }
    
    //метод для нажатия на accessoryView (кнопка избранного)
    @objc func favoritePressed(sender: AnyObject) {
        //определение места касания и индекса строки tableview
        let touchPoint: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        let index = self.tableView.indexPathForRow(at: touchPoint)
        
        if let item = channelItems?[index!.row]
        {
            do {
                try realm.write {
                    item.subscribe = !item.subscribe
                }
            } catch let error {
                print(error)
            }
            }
        tableView.reloadData()
    }
    
    
}
