//
//  HomeTableViewCell.swift
//  netflixclone_swift
//
//  Created by may on 1/12/23.
// one cell in a table with multiple collections (boxes)

import UIKit

// add custom function when cell in collection is tapped, all actions should be in VC
protocol HomeTableViewCellDelegate: AnyObject {
	func homeTableViewCellDidTapCell(model: Film)
}

class HomeTableViewCell: UITableViewCell {

	
    static let identifier = "HomeTableViewCell"
	private var films: [Film] = [Film]()
	// from protocol
	weak var delegate: HomeTableViewCellDelegate?

	// per row is a collectionview horizontal scroll
	private let scrollingCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize(width: 140, height: 200) //per movie box
	
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		//register cell
		cv.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
		
		return cv
	}()
		
	
	// MARK: - Main
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureScrollCV()
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		scrollingCollectionView.frame = bounds
	}
	
	// MARK: - Public Configure Method
	func configure(with films: [Film]){
		self.films = films
		DispatchQueue.main.async { [weak self] in
			self?.scrollingCollectionView.reloadData()
		}
	}
	
	// MARK: - Private Methods
	private func downloadAction(indexPath: IndexPath){
		DataPersistenceManager.shared.saveAsFilmItem(model: films[indexPath.row]) { result in
			switch result {
				case .success():
					NotificationCenter.default.post(Notification(name: NSNotification.Name("downloaded")))
				case .failure(let error):
					print(error, "HomeTableViewCell, downloadAction() ")
			}
		}
	}
	
	private func configureScrollCV(){
		contentView.addSubview(scrollingCollectionView)
		scrollingCollectionView.dataSource = self
		scrollingCollectionView.delegate = self
	}
	
	
	required init(coder: NSCoder) {
		fatalError("ERROR: HomeTableViewCell")
	}
	
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as? FilmCollectionViewCell else { return UICollectionViewCell() }
		
		let content = films[indexPath.row]
		let title = content.title ?? content.name ?? content.original_title ?? content.original_name ?? "No Title"
		let model = FilmViewModel(title: title, posterURL: content.poster_path ?? "")
		cell.configure(with: model)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return films.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		
		let selected = films[indexPath.row]
		delegate?.homeTableViewCellDidTapCell(model: selected)
	}
	
	// contextMenuConfigurationForItemsAt => menu popup when longpressed
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
		
		let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
			
			let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
				self?.downloadAction(indexPath: indexPaths[0])
			}
			return UIMenu(title: "What do you want?", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
		}
		
		return config
	}
	
	
}


