//
//  NewAndHotViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/25/23.
//

import UIKit
import Combine

class NewAndHotViewController: UIViewController{
	
	private var films = Dictionary<Int, [Film]>()
	private var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
	
	private lazy var selectedProfile: UserProfile? = AppSettings.selectedProfile {
		didSet{
			if let urlString = AppSettings.selectedProfile?.userProfileIcon, let imageURL = URL(string: urlString){
				profileBtn.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImage(systemName: "face.dashed.fill"), options: [.progressiveLoad])
			}
			
		}
	}
	
	private let RemindMeViewModel = RemindMeViewViewModel()
	private let MyListViewModel = MyListViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
	private let sectionBarView = NewHotHeaderView()
	
	private let sectionHeader = [
		Section(title: "Coming Soon", icon: "popcorn"),
		Section(title: "Everyone's Watching", icon: "fire"),
		Section(title: "Top 5 TV Shows", icon: "top10"),
		Section(title: "Top 5 Movies", icon: "top10"),
	]
	
	
	private let tableViewCells: [(cellType: UITableViewCell.Type, reuseIdentifier: String)] = [
		(ComingSoonTableViewCell.self, ComingSoonTableViewCell.identifier),
		(PopularTableViewCell.self, PopularTableViewCell.identifier),
		(Top10TableViewCell.self, Top10TableViewCell.identifier),
		(Top10TableViewCell.self, Top10TableViewCell.identifier)
	]
	
	
	private lazy var VCTable: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		
		for x in tableViewCells{
			table.register(x.cellType, forCellReuseIdentifier: x.reuseIdentifier)
		}
		table.delegate = self
		table.dataSource = self
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()
	
	private lazy var profileBtn = {
		let btn = ProfileButton()
		btn.delegate = self
		
		return btn
	}()
	
	// MARK: - Main
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		fetchUpcomingFromAPI()
		fetchPopularFromAPI()
		fetchTrendingFromAPI(media_type: MediaType.tv, tableSection: 2)
		fetchTrendingFromAPI(media_type: MediaType.movie, tableSection: 3)
		
		configureNavbar()
		configureSectionBar()
		view.addSubview(VCTable)
		
		bindViews()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		NSLayoutConstraint.activate([
			sectionBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			sectionBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sectionBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			sectionBarView.heightAnchor.constraint(equalToConstant: 50)
		])
		
		NSLayoutConstraint.activate([
			VCTable.topAnchor.constraint(equalTo: sectionBarView.bottomAnchor),
			VCTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			VCTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			VCTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		print("viewWillAppear")
		selectedProfile = AppSettings.selectedProfile
		RemindMeViewModel.retrieveRemindMeFilms()
		MyListViewModel.retrieveMyListFilms()
	}
	
	
	// MARK: - Private Methods
	
	private func bindViews(){
		RemindMeViewModel.$remindMeFilms.sink { [weak self] _ in
			print("table reloaded")
			DispatchQueue.main.async {
				self?.VCTable.reloadSections(IndexSet(integer: 0), with: .automatic)
			}
		}
		.store(in: &subscriptions)
		
		MyListViewModel.$myListFilms.sink { [weak self] _ in
			print("table reloaded")
			DispatchQueue.main.async {
				self?.VCTable.reloadSections(IndexSet(integersIn: 1...3), with: .automatic)
			}
		}
		.store(in: &subscriptions)
		
	}
	
	private func configureNavbar(){
		//navbar tabbar config
		let navbar = navigationController!.navigationBar
		
		navbar.tintColor = .label
		
		//left
		let titleLabel = UILabel()
		titleLabel.text = "New & Hot"
		titleLabel.font = .systemFont(ofSize: 25, weight: .heavy)
		titleLabel.textColor = .label
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
		
		//right
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(customView: profileBtn),
			UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(didTapBell)),
		]
		
	}
	
	@objc private func didTapBell(){
		let vc = RemindMeViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	private func configureSectionBar(){
		// Set up and configure the section header view
		view.addSubview(sectionBarView)
		sectionBarView.sectionItems = sectionHeader
		sectionBarView.translatesAutoresizingMaskIntoConstraints = false
		sectionBarView.didSelectSection = { [weak self] section in
			self?.VCTable.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
		}
	}
	
	private func fetchUpcomingFromAPI(media_type: MediaType = .movie, total_results: Int = 5){
		APICaller.shared.getUpcoming(media_type: media_type.rawValue) { [weak self] result in
			switch result{
				case .success(let list):
					self?.films[0] = list
					print("num of upcoming films",list.count)
					DispatchQueue.main.async {
						self?.VCTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
					}
					
				case .failure(let error):
					print(error)
			}
		}
	}
	
	private func fetchPopularFromAPI(media_type: MediaType = .movie, total_results: Int = 5){
		APICaller.shared.getPopular(media_type: media_type.rawValue) { [weak self] results in
			switch results {
				case .success(let list):
					self?.films[1] = Array(list.suffix(total_results))

				case .failure(let error):
					print(error)
			}
		}
	}
	
	private func fetchTrendingFromAPI(media_type: MediaType = .all, total_results: Int = 5, tableSection: Int){
		APICaller.shared.getTrending(media_type: media_type.rawValue) { [weak self] result in
			switch result {
				case .success(let list):
					self?.films[tableSection] = Array(list.suffix(total_results))
				case .failure(let error):
					print(error)
			}
		}
	}
	
	
	
	
	
	
}

extension NewAndHotViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section{
			case 0: //upcoming
				return films[0]?.count ?? 2
			default:
				return 5
				
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		
		let reuseIdentifier = tableViewCells[indexPath.section].reuseIdentifier

		switch indexPath.section {
			case 0:
				guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ComingSoonTableViewCell else { return UITableViewCell() }
				
				guard let filmModel = films[indexPath.section]?[indexPath.row] else {
					tableView.reloadData()
					return cell
				}
				
				let remindMeSelected = RemindMeViewModel.remindMeFilms.contains(where: {$0.id == filmModel.id})
			
				cell.configureDetails(model: filmModel)
				cell.configureTabView(model: filmModel, remindMeSelected)
				cell.selectionStyle = .none
				
				return cell
			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PopularTableViewCell
				guard let filmModel = films[indexPath.section]?[indexPath.row] else { return UITableViewCell() }
				
				let myListSelected = MyListViewModel.myListFilms.contains(where: {$0.id == filmModel.id})
				
				cell.configureTabView(model: filmModel, myListSelected)
				cell.configureDetails(with: filmModel)
				cell.selectionStyle = .none
				return cell

			default:
				let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Top10TableViewCell
				guard let filmModel = films[indexPath.section]?[indexPath.row] else { return UITableViewCell() }
				
				let myListSelected = MyListViewModel.myListFilms.contains(where: {$0.id == filmModel.id})
				
				cell.configureTabView(model: filmModel, myListSelected)
				cell.configureDetails(with: filmModel, top: indexPath.row + 1)
				cell.selectionStyle = .none
				return cell

		}
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionHeader.count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
		
		let iconImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
		iconImageView.image = UIImage(named: sectionHeader[section].icon)
		headerView.addSubview(iconImageView)

		let titleLabel = UILabel(frame: CGRect(x: 40, y: 10, width: tableView.frame.size.width - 50, height: 20))
		titleLabel.textColor = .label
		titleLabel.text = sectionHeader[section].title
		titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
		headerView.addSubview(titleLabel)

		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 400
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		sectionBarView.selectedIndexPath.row = section
		sectionBarView.sectionCollectionView.scrollToItem(at: IndexPath(row: section, section: 0), at: [], animated: true)
	}
}



extension NewAndHotViewController: ProfileButtonDelegate {
	func didTapProfileButton() {
		let profileVC = ProfileViewController()
		navigationController?.pushViewController(profileVC, animated: true)
	}
}
