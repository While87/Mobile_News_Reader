//
//  ChannelAndNewsManager.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 13.04.2021.
//

import Foundation
import RealmSwift

protocol ChannelAndNewsManagerDelegate {
    func didUpdateData(data: Any?)
    func didFailWhithError(_ error: String)
}


struct ChannelAndNewsManager {
    
    let APIKey = "5374ef471906409794d6fcd3af48e68c"
    //let APIKey = "a6e99722e4d641a8b686f46e893d1311"
    
    var delegate: ChannelAndNewsManagerDelegate?
    
    func fetchChannels() {
        let channelsURL = "https://newsapi.org/v2/sources?apiKey=\(APIKey)"
        requestChannelsData(urlString: channelsURL)
    }
    
    func fetchNews(channelSource: String) {
        let newsURL = "https://newsapi.org/v2/top-headlines?sources=\(channelSource)&apiKey=\(APIKey)"
        requestNewsData(urlString: newsURL)
    }
    
    func searchNews(searchRequest: String){
        let search = searchRequest.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)!
        let searchURL = "https://newsapi.org/v2/everything?q=\(search)&apiKey=\(APIKey)"
        searchRequestt(urlString: searchURL)
    }

    //Любые попытки унифицировать код и поделить на ветвления упирается в то,что много мест зависит от конкретных типов данных и на кажущееся повторение кода, упрощение требует более детального разбора ситуации, как вариант перейти на switch/case
    func requestChannelsData(urlString: String) {
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { [self] (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWhithError(error!.localizedDescription)
                    return
                }
                if data != nil {
                    if let channelData = parseChannelsJSON(data!){
                        
                        let realm = try! Realm()
                        do {
                            try realm.write {
                                
                                for item in channelData.sources {
                                
                                    let data = ChannelRM()
                                    data.id = item.id
                                    data.title = item.name
                                    data.descript = item.description
                                    realm.add(data)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        self.delegate?.didUpdateData(data: Any?.self)
                    }
                }
        }
        task.resume()
    }
    
    func requestNewsData(urlString: String) {
        let url = URL(string: urlString)
        print(urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { [self] (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWhithError(error!.localizedDescription)
                    return
                }
                if data != nil {
                    if let newsData = parseNewsJSON(data!){
                        
                        let realm = try! Realm()
                        do {
                            try realm.write {
                                
                                for item in newsData.articles {
                                
                                    let data = NewsRM()
                                    
                                    if realm.objects(NewsRM.self).filter("url == '\(item.url)' AND publishedAt == '\(item.publishedAt)'").isEmpty
                                    {
                                        
                                        data.title = item.title
                                        data.descript = item.description
                                        data.content = item.content
                                        data.url = item.url
                                        data.publishedAt = item.publishedAt
                                        
                                       
                                       if item.urlToImage != nil {
                                        //Периодически ловится ошибка - nill в качестве URL. Хотя он !=nil. БАГ???
                                        if let imageData = try? Data(contentsOf: (URL(string: item.urlToImage!)!)) {
                                                data.image? = imageData
                                            }
                                        }
                                        
                                    realm.add(data)
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        self.delegate?.didUpdateData(data: Any?.self)
                    }
                }
        }
        task.resume()
    }
    
    func searchRequestt(urlString: String) {
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { [self] (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWhithError(error!.localizedDescription)
                    return
                }
                if data != nil {
                    if let newsData = parseNewsJSON(data!){
                        self.delegate?.didUpdateData(data: newsData)
                    }
                }
        }
        task.resume()
    }
    
    func parseChannelsJSON(_ channelsData: Data) -> ChannelData? {
        let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(ChannelData.self, from: channelsData)
                return decodedData
            } catch {
                let errorData = try! decoder.decode(ErrorData.self, from: channelsData)
                print(errorData.message)
                delegate?.didFailWhithError(errorData.message)
                return nil
            }
        }
    
    func parseNewsJSON(_ newsData: Data) -> NewsData? {
        let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(NewsData.self, from: newsData)
                return decodedData
            } catch {
                print(error)
                let errorData = try! decoder.decode(ErrorData.self, from: newsData)
                print(errorData.message)
                delegate?.didFailWhithError(errorData.message)
                return nil
            }
        }
  }
