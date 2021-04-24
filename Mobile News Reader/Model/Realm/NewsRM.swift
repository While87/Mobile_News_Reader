//
//  NewsRealmModel.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 14.04.2021.
//

import Foundation
import RealmSwift

class NewsRM: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descript: String?  //Неудается объявить переменную как - description, слово зарезервировано системой
    @objc dynamic var content: String?
    @objc dynamic var url: String = ""
    @objc dynamic var image: Data? = UIImage(named: "1x1.png")?.pngData()
    @objc dynamic var publishedAt: String = ""
}
