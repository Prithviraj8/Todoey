//
//  Category.swift
//  Todoey
//
//  Created by ts krishna on 20/04/18.
//  Copyright © 2018 Prithviraj. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()

    
    
    
}




