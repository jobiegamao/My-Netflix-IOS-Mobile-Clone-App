//
//  ProfileViewController.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import UIKit
import FirebaseAuth
import Combine

class ProfileViewController: UIViewController {
	
	private var viewModel = ProfileViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
	private var profileBtns = [UserProfileButton]()
	
	private var selectedProfile: UserProfile? {
		didSet{
			profileBtns.forEach{ btn in
				if btn.userProfile?.id == selectedProfile?.id{
					btn.iconImageView.layer.borderColor = UIColor.label.cgColor
					btn.iconImageView.layer.borderWidth = 1
				}else{
					btn.iconImageView.layer.borderWidth = 0
				}
					
			}
		}
	}
	
	private lazy var myProfilesView: UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.alignment = .center
		stack.distribution = .equalCentering
		return stack
	}()
	
	private lazy var manageProfileBtn: ButtonImageAndText = {
		let btn = ButtonImageAndText(text: "Manage Profiles", image: UIImage(systemName: "square.and.pencil"), iconPlacement: .left)
		btn.label.font = .systemFont(ofSize: 20, weight: .semibold)
		btn.addTarget(self, action: #selector(didTapManageProfile), for: .touchUpInside)
		return btn
	}()
	
	private lazy var signOutBtn: UIButton = {
		let btn = UIButton(type: .system)
		btn.setTitle("Sign Out", for: .normal)
		btn.setTitleColor(.label, for: .normal)
		btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
		btn.translatesAutoresizingMaskIntoConstraints = false
		
		btn.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
		return btn
	}()
	
	private lazy var actionsView: UITableView = {
		let table = UITableView()
		table.translatesAutoresizingMaskIntoConstraints = false
		table.register(ActionsTableViewCell.self, forCellReuseIdentifier: ActionsTableViewCell.identifier)
		
		table.delegate = self
		table.dataSource = self
		return table
	}()
	
	private let actionsViewCells = [
		Section(title: "Notifications", icon: "bell.badge"),
		Section(title: "My List", icon: "play.tv"),
		Section(title: "Account", icon: "person.badge.key.fill"),
		Section(title: "Settings", icon: "gear.circle"),
	]

	// MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		title = "Profiles & More"
		
		view.addSubview(myProfilesView)
		view.addSubview(manageProfileBtn)
		view.addSubview(actionsView)
		view.addSubview(signOutBtn)
		
		applyConstraints()
		bindViews()
		
		NotificationCenter.default.addObserver(forName: .didAddNewProfile, object: nil, queue: nil) { _ in
			self.viewModel.retrieveUser()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.retrieveUser()
		selectedProfile = AppSettings.selectedProfile
	}
	
	// MARK: - Private Methods
	
	
	private func bindViews(){
		
		//when profile changes
		viewModel.$profiles.sink { [weak self] profileArrayResult in
			//empty everything first
			self?.profileBtns.removeAll()
			self?.myProfilesView.removeAllSubviews()
			
			//fill data
			self?.profileBtns = profileArrayResult.map { [weak self] userProfile in
				let btn = UserProfileButton(userProfile: userProfile)
				btn.addTarget(self, action: #selector(self?.didTapProfileButton(_:)), for: .touchUpInside)
				if userProfile.id == self?.selectedProfile?.id{
					btn.iconImageView.layer.borderColor = UIColor.label.cgColor
					btn.iconImageView.layer.borderWidth = 1
				}else{
					btn.iconImageView.layer.borderWidth = 0
				}
				
				return btn
			}
			
			self?.profileBtns.forEach { btn in
				self?.myProfilesView.addArrangedSubview(btn)
			}
			
		
		}
		.store(in: &subscriptions)
		
	}
	
	@objc private func didTapManageProfile(){
		let vc = ManageProfilesViewController()
		present(vc, animated: true)
	}
	
	@objc private func didTapProfileButton(_ sender: UserProfileButton){
		guard let userProfile = sender.userProfile  else { return  }
		UserDefaults.standard.set(userProfile.id, forKey: AppSettings.selectedProfileIDForKey)
		AppSettings.selectedProfile = userProfile
		selectedProfile = userProfile
		
		// to go back to the previous view controller
		navigationController?.popViewController(animated: true)
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			myProfilesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			myProfilesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			myProfilesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
			myProfilesView.heightAnchor.constraint(equalToConstant: 100),
			
			manageProfileBtn.topAnchor.constraint(equalTo: myProfilesView.bottomAnchor, constant: 15),
			manageProfileBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			actionsView.topAnchor.constraint(equalTo: manageProfileBtn.bottomAnchor, constant: 35),
			actionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			actionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			actionsView.heightAnchor.constraint(equalToConstant: 300),
			
			signOutBtn.topAnchor.constraint(equalTo: actionsView.bottomAnchor, constant: 25),
			signOutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
		])
	}
	
	@objc private func didTapSignOut(){
		try? Auth.auth().signOut()
		
		AppSettings.selectedProfile = nil
		UserDefaults.standard.set(nil, forKey: AppSettings.selectedProfileIDForKey)
		
		if Auth.auth().currentUser == nil {
			let vc = OnboardingViewController()
			let rootNavController = UINavigationController(rootViewController: vc)
			rootNavController.modalPresentationStyle = .fullScreen
			present(rootNavController, animated: false)
		}
	}
	
    

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return actionsViewCells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsTableViewCell.identifier, for: indexPath) as? ActionsTableViewCell else {return UITableViewCell()}
		
		cell.configureCell(with: actionsViewCells[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		switch indexPath.row {
			case 0: // Notif
				let vc = RemindMeViewController()
				navigationController?.pushViewController(vc, animated: true)
			case 1: // My List
				let vc = MyListViewController()
				navigationController?.pushViewController(vc, animated: true)
			default:
				break
		}
	}
	
	
	
}
