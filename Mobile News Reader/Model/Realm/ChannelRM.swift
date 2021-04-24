//
//  ChannelRealmModel.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 14.04.2021.
//

import Foundation
import RealmSwift

class ChannelRM: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descript: String = ""
    @objc dynamic var subscribe: Bool = false
}
