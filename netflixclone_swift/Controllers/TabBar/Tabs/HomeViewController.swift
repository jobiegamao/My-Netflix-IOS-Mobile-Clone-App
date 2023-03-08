//
//  HomeViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
	
	private var viewModel = HomeViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
	private let homeTable: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		//table is groupstyle for header for each row
		
		//register cell
		table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
		
		return table
	}()
	
	private lazy var profileBtn = {
		let btn = ProfileButton()
		btn.setImage(UIImage(systemName: "face.dashed.fill"), for: .normal)
		btn.delegate = self
		return btn
	}()

	
	private let sectionHeader = ["Popular on Netflix",
								 "Trending Shows",
								 "Top picked Movies",
								 "Upcoming"]
	
	
	
	// MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
        
		configureNavbar()
		configureTable()
		
		bindViews()
		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		homeTable.frame = view.bounds //same size to view
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		handleAuthentication()
		viewModel.retrieveUser()
		
		if let selectedProfile = AppSettings.selectedProfile{
			viewModel.currentUserProfile = selectedProfile
		}
		
	}
	
	
	// MARK: - Private Methods
	
	private func handleAuthentication(){
	
		if Auth.auth().currentUser == nil {
			let vc = UINavigationController(rootViewController: OnboardingViewController())
			vc.modalPresentationStyle = .fullScreen
			present(vc, animated: false)
		}
		
	}
	
	private func configureNavbar(){
		
		//left
		var image = UIImage(named: "netflixLogo")
		image = image?.withRenderingMode(.alwaysOriginal) //use image as is
		let logoBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
		logoBtn.imageInsets = UIEdgeInsets(top: 0, left: -39, bottom: -5, right: 0)
		navigationItem.leftBarButtonItem = logoBtn
		
		//right
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(customView: profileBtn),
			UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearch)),
			UIBarButtonItem(image: UIImage(systemName: "airplayvideo"), style: .plain, target: self, action: nil)
		]
		
		navigationController?.navigationBar.tintColor = .label
		
	}
	
	@objc private func didTapSearch(){
		let vc = SearchViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	private func fetchListFromAPI(cell: HomeTableViewCell, category: Categories, media_type: MediaType, language: String = Language.English.rawValue, time_period: String = "day", page: Int = 1) {
		switch category {
			case .Trending:
				APICaller.shared.getTrending(media_type: media_type.rawValue, time_period: time_period) { results in
					switch results {
						case .success(let films):
							cell.configure(with: films)
						case .failure(let error):
							print(error)
					}
				}
				
			case .Popular:
				APICaller.shared.getPopular(media_type: media_type.rawValue) { results in
					switch results {
						case .success(let films):
							cell.configure(with: films)
						case .failure(let error):
							print(error)
					}
				}
	
			case .Upcoming:
				APICaller.shared.getUpcoming(media_type: media_type.rawValue) { results in
					switch results {
						case .success(let films):
							cell.configure(with: films)
						case .failure(let error):
							print(error)
					}
				}
			
			case .TopRated:
				APICaller.shared.getTopRated(media_type: media_type.rawValue, language: language) { results in
					switch results {
						case .success(let films):
							cell.configure(with: films)
						case .failure(let error):
							print(error)
					}
				}
		
			
			
		}
	}
	
	private func configureTable(){
		view.addSubview(homeTable)
		homeTable.delegate = self
		homeTable.dataSource = self
		
		//MAIN HEADER of HOME
		let homeTableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 600))
		homeTable.tableHeaderView = homeTableHeaderView
	}
	
	private func bindViews(){
		viewModel.$user.sink { [weak self] user in
			if AppSettings.selectedProfile == nil {
				guard let id =  UserDefaults.standard.string(forKey: AppSettings.selectedProfileIDForKey) else {
					let vc = WhosWatchingViewController()
					self?.present(vc, animated: true)
					return
				}
				
				self?.viewModel.retrieveCurrentUserProfile(profileID: id) { result in
					switch result {
						case .success(let userProfile):
							AppSettings.selectedProfile = userProfile
						case .failure(let error):
							print(error)
					}
				}
			}
		}
		.store(in: &subscriptions)
		
		viewModel.$currentUserProfile.sink { [weak self] selectedProfile in
			guard let selectedProfile = selectedProfile else {return}
			let imageURL = URL(string: selectedProfile.userProfileIcon)
			self?.profileBtn.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImage(systemName: "face.dashed.fill"), options: [.progressiveLoad])

		}
		.store(in: &subscriptions)


	}
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	//whats in each cell row
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
		
		cell.delegate = self
		
		switch indexPath.section{
			case 0:
				fetchListFromAPI(cell: cell, category: Categories.Trending, media_type: MediaType.all)
			case 1:
				fetchListFromAPI(cell: cell, category: Categories.Popular, media_type: MediaType.tv)
			case 2:
				fetchListFromAPI(cell: cell, category: Categories.TopRated, media_type: MediaType.movie)
			case 3:
				fetchListFromAPI(cell: cell, category: Categories.Upcoming, media_type: MediaType.movie)

			default:
				return UITableViewCell()
		}
		
		
		
		return cell
	}
	
	//how many sections
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionHeader.count
	}
	
	
	// rows per section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	
	//header config
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
		
		guard let header = view as? UITableViewHeaderFooterView else {return}
		var config = header.defaultContentConfiguration()
		config.textProperties.font = .systemFont(ofSize: 20, weight: .heavy)
		config.textProperties.color = .secondaryLabel
		config.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

		if let title = self.tableView(tableView, titleForHeaderInSection: section)?.capitalized{
			config.attributedText = NSAttributedString(string: title, attributes: [:])
		}
		
		header.contentConfiguration = config
	}
	
	// header display
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionHeader[section]
	}
	
	// SIZE of CELL
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
	
	
	
}

extension HomeViewController: HomeTableViewCellDelegate{
	func homeTableViewCellDidTapCell(model: Film) {
		
		let vc = FilmDetailsViewController()
		vc.configure(model: model)
		present(vc, animated: true)
	}
}

extension HomeViewController: ProfileButtonDelegate {
	func didTapProfileButton() {
		let profileVC = ProfileViewController()
		navigationController?.pushViewController(profileVC, animated: true)
	}
}




