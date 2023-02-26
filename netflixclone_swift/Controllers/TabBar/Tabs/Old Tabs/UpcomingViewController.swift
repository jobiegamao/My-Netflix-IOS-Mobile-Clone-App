//
//  UpcomingViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
//

import UIKit

class UpcomingViewController: UIViewController {

	private var films = [Film]()

	private let upcomingFilmsTable: UITableView = {
		let table = UITableView()
		table.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
		return table
	}()
	
	func fetchUpcomingFromAPI(media_type: MediaType){
		APICaller.shared.getUpcoming(media_type: media_type.rawValue) { [weak self] result in
			switch result{
				case .success(let list):
					self?.films = list
					DispatchQueue.main.async {
						self?.upcomingFilmsTable.reloadData()
					}
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		title = "Upcoming"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationItem.largeTitleDisplayMode = .always
		
		view.addSubview(upcomingFilmsTable)
		upcomingFilmsTable.dataSource = self
		upcomingFilmsTable.delegate = self
		
		fetchUpcomingFromAPI(media_type: MediaType.movie)
		
		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		upcomingFilmsTable.frame = view.bounds
	}
    
	

    

}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return films.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as? FilmTableViewCell else { return UITableViewCell() }
		
		cell.configure(with: FilmViewModel(title: films[indexPath.row].title ?? films[indexPath.row].name ?? films[indexPath.row].original_title ?? "No Name", posterURL: films[indexPath.row].poster_path ?? "No Poster"))

		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let film = films[indexPath.row]
		guard let filmTitle = film.title ?? film.name ?? film.original_name ?? film.original_title else { return }
		
		APICaller.shared.getFilmYoutubeVideo(query: filmTitle + " trailer") { [weak self] result in
			switch result {
				case .success(let searchResult):
					DispatchQueue.main.async {
						let vc = FilmDetailsViewController()
						vc.configure(model: film)
						self?.navigationController?.pushViewController(vc, animated: true)
					}
					
				case .failure(let error):
					print(error)
			}
			
		}
		
	}
}
