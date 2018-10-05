//
//  TabBarController.swift
//  WorldWide
//
//  Created by Hoang Trong Anh on 3/12/18.
//  Copyright © 2018 Hoang Trong Anh. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class RootTabBarController: ASTabBarController {

    private var googleTab: ASNavigationController = {
        let tab = ASNavigationController(rootViewController: GoogleViewController())
        tab.tabBarItem.title = nil
        tab.tabBarItem.image = #imageLiteral(resourceName: "icn_tabbar_news")
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        return tab
    }()
    
    private var newTab: ASNavigationController = {
        let tab = ASNavigationController(rootViewController: NewViewController())
        tab.tabBarItem.title = nil
        tab.tabBarItem.image = #imageLiteral(resourceName: "icn_tabbar_news")
        tab.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return tab
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = [self.googleTab, self.newTab]
        self.selectedIndex = 0
        self.tabBar.tintColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
