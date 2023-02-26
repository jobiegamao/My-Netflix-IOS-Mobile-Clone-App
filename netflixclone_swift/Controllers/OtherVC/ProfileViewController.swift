//
//  ProfileViewController.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import UIKit

class ProfileViewController: UIViewController {
	
	private let myProfilesView = {
		let view = UIView()
		view.backgroundColor = .systemPink
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var manageProfileBtn: ButtonImageAndText = {
		let btn = ButtonImageAndText(text: "Manage Profiles", image: UIImage(systemName: "square.and.pencil"), iconPlacement: .left)
		return btn
	}()
	
	private lazy var signOutBtn: UIButton = {
		let btn = UIButton(type: .system)
		btn.setTitle("Sign Out", for: .normal)
		btn.setTitleColor(.label, for: .normal)
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()
	
	private lazy var actionsTableView: UITableView = {
		let table = UITableView()
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()

	//MARK: main
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		title = "Profiles & More"
		
		view.addSubview(myProfilesView)
		view.addSubview(manageProfileBtn)
		view.addSubview(signOutBtn)
		
		applyConstraints()
    }
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			
		])
		ss
	}
    

}
