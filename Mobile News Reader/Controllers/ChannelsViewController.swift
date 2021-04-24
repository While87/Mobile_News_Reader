//
//  ChannelsViewController.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 12.04.2021.
//

import UIKit
import RealmSwift

class ChannelsViewController: UIViewController {
        
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var channelItems: Results<ChannelRM>?
    
    let cellId = "ChannelTableViewCell" //Идентификатор для ячеек ленты
    
    var channelManager = ChannelAndNewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelItems = realm.objects(ChannelRM.self)
        
        channelManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //регистрируем Nib
        tableView.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        loadChannelItems()
    }
    
    func loadChannelItems() {
        if realm.objects(ChannelRM.self).isEmpty {
            channelManager.fetchChannels()
        }
    }
    
    //Перезагружаем таблицу, что бы при переходе по tabBar иметь свежие данные в случае изменения каких либо элементов
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension ChannelsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChannelTableViewCell
        
        cell.channelTitle.text = channelItems?[indexPath.row].title ?? "No data loaded, please try again!"
        cell.channelDescription.text = channelItems?[indexPath.row].descript ?? "And check network connection!"
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
   


//MARK: - ChannelAndNewsManagerDelegate
extension ChannelsViewController: ChannelAndNewsManagerDelegate {
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
