//
//  TabBarVM.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/10/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

protocol TabBarVMProtocol {
    var names: [String] { get set }
}

class TabBarVM: TabBarVMProtocol {
    var names = ["Cat-a-log", "Cat-a-gram", "Cat-a-quiz"]
}
