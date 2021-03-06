//
//  TabBarVC.swift
//  Caturday
//
//  Created by Oleksii Kaharov on 5/10/20.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    var viewModel: TabBarVM = TabBarVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    func setTabBar() {
        if let vcs = viewControllers {
            for index in 0..<vcs.count {
                let vc = vcs[index]
                switch index {
                case 0:
                    vc.tabBarItem = UITabBarItem(title: viewModel.names[index],
                                                 image: UIImage(named: "Cat-icon_small"),
                                                 tag: index)
                case 1:
                    vc.tabBarItem = UITabBarItem(title: viewModel.names[index],
                                                 image: UIImage(named: "photos_small"),
                                                 tag: index)
                case 2:
                    vc.tabBarItem = UITabBarItem(title: viewModel.names[index],
                                                 image: UIImage(named: "cat_q"),
                                                 tag: index)
                default:
                    break
                }
                
            }
        }
    }
}
