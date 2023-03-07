//
//  RemindMeViewController.swift
//  netflixclone_swift
//
//  Created by may on 3/6/23.
//

import UIKit
import Combine

class RemindMeViewController: UIViewController {

	private let viewModel = RemindMeViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
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
		
		title = "Reminders for \(AppSettings.selectedProfile?.userProfileName ?? "You")"
		
		view.addSubview(VCtable)
		
		// Bring the table view to the back
		VCtable.layer.zPosition = -1
		bindViews()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		VCtable.frame = view.bounds
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.retrieveRemindMeFilms()
	}
	
	// MARK: - Private Methods
	
	private func bindViews(){
		viewModel.$remindMeFilms.sink { [weak self] _ in
			DispatchQueue.main.async {
				self?.VCtable.reloadData()
			}
		}
		.store(in: &subscriptions)
	}
	
	
	

}

extension RemindMeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.remindMeFilms.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as? FilmTableViewCell else { return UITableViewCell()}
		
		cell.configure(with: viewModel.remindMeFilms[indexPath.row])
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 140
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
			case .delete:
				let filmToDelete = viewModel.remindMeFilms[indexPath.row]
				viewModel.deleteFilm(model: filmToDelete) { [weak self] result in
					switch result {
					case .success:
							self?.viewModel.remindMeFilms.remove(at: indexPath.row)
							tableView.deleteRows(at: [indexPath], with: .right)
					case .failure(let error):
						print("Error deleting film: \(error.localizedDescription)")
					}
				}
				
			default:
				break
		}
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let model = viewModel.remindMeFilms[indexPath.row]

		DispatchQueue.main.async { [weak self] in
			let vc = FilmDetailsViewController()
			vc.configure(model: model)
			self?.present(vc, animated: true)
		}
		
	}
	
}

