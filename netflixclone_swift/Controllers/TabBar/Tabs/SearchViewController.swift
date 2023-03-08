//
//  SearchViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
// old search view

import UIKit

class SearchViewController: UIViewController {

	private var films: [Film] = [Film]()
	
	private let searchController: UISearchController = {
		let controller = UISearchController(searchResultsController: SearchResultsViewController())
		controller.searchBar.placeholder = "Search.."
		controller.searchBar.searchBarStyle = .minimal
		controller.searchBar.showsCancelButton = false
		return controller
	}()
	
	private let discoverTable: UITableView = {
		let table = UITableView()
		table.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
		return table
	}()
	
	// MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		title = "Search"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		
		navigationItem.searchController = searchController
		searchController.searchResultsUpdater = self
		
		view.addSubview(discoverTable)
		discoverTable.delegate = self
		discoverTable.dataSource = self
		
		fetchDiscoverFromAPI(media_type: MediaType.tv)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		discoverTable.frame = view.bounds
	}
	
	private func fetchDiscoverFromAPI(media_type: MediaType){
		APICaller.shared.getDiscover(media_type: media_type.rawValue) { [weak self] result in
			switch result {
				case .success(let list):
					self?.films = list
					DispatchQueue.main.async {
						self?.discoverTable.reloadData()
					}
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
		let selectedFilm = films[indexPath.row]
		cell.configure(with: selectedFilm)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return films.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 140
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let model = films[indexPath.row]
	
		let vc = FilmDetailsViewController()
		vc.configure(model: model)
		present(vc, animated: true)
		
	}
	
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelagate {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		guard let query = searchBar.text, !query.isEmpty, let resultsVC = searchController.searchResultsController as? SearchResultsViewController else {return}
		
		//added with SearchResultsViewControllerDelagate, so cells in resultsVC will be accecesed there
		resultsVC.delegate = self
		
		APICaller.shared.search(with: query) { result in
			switch result{
				case .success(let list):
					resultsVC.films = list
					DispatchQueue.main.async {
						resultsVC.resultsCollectionView.reloadData()
					}
	
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}
	
	func searchResultsViewControllerDidTapCell(model: Film) {
//		
//		let vc =  FilmDetailsViewController()
//		vc.configure(model: model)
//		navigationController?.pushViewController(vc, animated: true)
	}
	
	
}
