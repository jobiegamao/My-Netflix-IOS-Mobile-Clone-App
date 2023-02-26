//
//  ViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
// main shared tab

import UIKit

// class is a tab bar
class MainTabBarViewController: UITabBarController {
	
	private let rootvc = [
		HomeViewController(),
		NewAndHotViewController(),
		SearchViewController(),
		DownloadsViewController()
	]
	
	private lazy var tabs: [UINavigationController] = rootvc.map{ vc in
		return UINavigationController(rootViewController: vc)
	}
	
	private let tabImage = [
		"house",
		"play.rectangle.on.rectangle",
		"magnifyingglass",
		"arrow.down.circle"
	]
	
	private let tabImage_selected = [
		"house.fill",
		"play.rectangle.on.rectangle.fill",
		"",
		"arrow.down.circle.fill"
	]
	
	private let tabTitles = [
		"Home",
		"New & Hot",
		"Top Search",
		"Downloads"
	]
	
	

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		tabBar.tintColor = .label
		tabBar.layer.zPosition = 99
		
		
		for (index, tab) in tabs.enumerated() {
			tab.tabBarItem.image = UIImage(systemName: tabImage[index])
			if(tabImage_selected[index] != ""){
				tab.tabBarItem.selectedImage = UIImage(systemName: tabImage_selected[index])
			}
			tab.title = tabTitles[index]
			
		}
		
		setViewControllers(tabs, animated: true)
		
		
	}
	


}


