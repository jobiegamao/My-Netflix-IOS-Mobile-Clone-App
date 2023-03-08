//
//  DownloadsViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
//

import UIKit

class DownloadsViewController: UIViewController {

	private var downloadsFilmItem = [FilmItem]()
	private var downloadsFilm = [Film]()
	
	private lazy var VCtable: UITableView = {
		let table = UITableView()
		table.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
		table.delegate = self
		table.dataSource = self
		table.clipsToBounds = true
		return table
	}()
	

	// MARK: - Main
	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		title = "Downloads"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationItem.largeTitleDisplayMode = .automatic
		
		
		view.addSubview(VCtable)
		
	    // Bring the table view to the back
		VCtable.layer.zPosition = -1
		
		NotificationCenter.default.addObserver(forName: .didTapDownload, object: nil, queue: nil) { _ in
			self.fetchLocalStorage()
		}
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		VCtable.frame = view.bounds
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		fetchLocalStorage()
	}
	
	// MARK: - Private Methods
	private func fetchLocalStorage(){
		DataPersistenceManager.shared.getFilmItemsOfProfile{ [weak self] result in
			switch result{
				case .success(let filmItems):
					self?.downloadsFilmItem = filmItems
					//convert film item to Film
					self?.downloadsFilm = filmItems.map{ $0.FilmItemToFilm() }
					
					DispatchQueue.main.async {
						self?.VCtable.reloadData()
					}
					
				case .failure(let error):
					print(error)
					
			}
		}
	}
	
	

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return downloadsFilmItem.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as? FilmTableViewCell else { return UITableViewCell()}
		
		cell.configure(with: downloadsFilm[indexPath.row])
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 140
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
			case .delete:
				DataPersistenceManager.shared.deleteFilmItemOfProfile(model: downloadsFilm[indexPath.row]){ [weak self] result in
					switch result{
						case .success(()):
							DispatchQueue.main.async {
								self?.downloadsFilmItem.remove(at: indexPath.row)
								self?.downloadsFilm.remove(at: indexPath.row)
								self?.VCtable.deleteRows(at: [indexPath], with: .automatic)
							}
							
						case .failure(let error):
							print(error, "Error:DownloadsVC,commit editingStyle ")
					}
				}
			default:
				break
		}
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let model = downloadsFilm[indexPath.row]

		let vc = FilmDetailsViewController()
		vc.configure(model: model)
		present(vc, animated: true)
	}
	
	
	
}

