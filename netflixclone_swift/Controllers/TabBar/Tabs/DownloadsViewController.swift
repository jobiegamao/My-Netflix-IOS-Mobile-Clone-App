//
//  DownloadsViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
//

import UIKit

class DownloadsViewController: UIViewController {

	private var downloads = [FilmItem]()
	
	private lazy var VCtable: UITableView = {
		let table = UITableView()
		table.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
		table.delegate = self
		table.dataSource = self
		table.clipsToBounds = true
		return table
	}()
	
	private func fetchLocalStorage(){
		DataPersistenceManager.shared.getDownloadedFilms { [weak self] result in
			switch result{
				case .success(let films):
					self?.downloads = films
					DispatchQueue.main.async {
						self?.VCtable.reloadData()
					}
				case .failure(let error):
					print(error)
					
			}
		}
	}

	
	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		title = "Downloads"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		
		
		view.addSubview(VCtable)
		
	    // Bring the table view to the back
		VCtable.layer.zPosition = -1
		
		fetchLocalStorage()
		NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
			self.fetchLocalStorage()
		}
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		VCtable.frame = view.bounds
	}
	
	

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return downloads.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as? FilmTableViewCell else { return UITableViewCell()}
		
		let film = downloads[indexPath.row]
		let film_title = film.title ?? film.name ?? film.original_title ?? film.original_name
		cell.configure(with: FilmViewModel(title: film_title ?? "No Title", posterURL: film.poster_path ?? ""))
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 140
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
			case .delete:
				DataPersistenceManager.shared.deleteDownload(filmID: downloads[indexPath.row].id){ [weak self] result in
					switch result{
						case .success(()):
							DispatchQueue.main.async {
								self?.downloads.remove(at: indexPath.row)
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
	
	func filmItemCDToFilmModel(filmItem: FilmItem) -> Film {
		let filmModel = Film(id: Int(filmItem.id) ,
							 media_type: filmItem.media_type,
							 title: filmItem.title,
							 name: filmItem.name,
							 original_title: filmItem.original_title,
							 original_name: filmItem.original_name,
							 overview: filmItem.overview,
							 poster_path: nil,
							 release_date: nil,
							 genre_ids: filmItem.genre_ids,
							 backdrop_path: nil)
		return filmModel
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let filmItem = downloads[indexPath.row]
		let model = filmItemCDToFilmModel(filmItem: filmItem)

		DispatchQueue.main.async { [weak self] in
			let vc = FilmDetailsViewController()
			vc.configure(model: model)
			self?.present(vc, animated: true)
		}
		
	}
	
	
}
