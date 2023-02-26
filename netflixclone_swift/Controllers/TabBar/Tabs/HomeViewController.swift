//
//  HomeViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
	
	
	private let homeTable: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		//table is groupstyle for header for each row
		
		//register cell
		table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
		
		return table
	}()
	
	private func configureNavbar(){
		var image = UIImage(named: "netflixLogo")
		image = image?.withRenderingMode(.alwaysOriginal) //use image as is
		let logoBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
		logoBtn.imageInsets = UIEdgeInsets(top: 0, left: -39, bottom: -5, right: 0)
		navigationItem.leftBarButtonItem = logoBtn
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil),
			UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil),
			UIBarButtonItem(image: UIImage(systemName: "airplayvideo"), style: .plain, target: self, action: nil)
		]
		navigationController?.navigationBar.tintColor = .label
		
	}
	
	private let sectionHeader = ["Popular on Netflix", "Trending Shows", "Top picked Movies", "Upcoming"]
	
	
	func fetchListFromAPI(cell: HomeTableViewCell, category: Categories, media_type: MediaType, language: String = Language.English.rawValue, time_period: String = "day", page: Int = 1) {
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
	
	
	// MARK: Main()
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
        
		configureNavbar()
		configureTable()
		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		homeTable.frame = view.bounds //same size to view
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// logout if no user account
		if Auth.auth().currentUser == nil{
			let vc = UINavigationController(rootViewController: OnboardingViewController()) 
			vc.modalPresentationStyle = .fullScreen
			present(vc, animated: false)
		}
	}
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	//whats in each cell row
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
			//if theres no collectionView cell then just return a plain table cell
			return UITableViewCell()
		}
		
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
	
//	 HEADER
	
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
		
		DispatchQueue.main.async { [weak self] in
			let vc = FilmDetailsViewController()
			vc.configure(model: model)
			self?.present(vc, animated: true)
			
		}
		
	}
	
	func didTapInfoButton(forFilm film: Film) {
		DispatchQueue.main.async { [weak self] in
			let vc = FilmDetailsViewController()
			vc.configure(model: film)
			self?.present(vc, animated: true)
			
		}
	}
}




