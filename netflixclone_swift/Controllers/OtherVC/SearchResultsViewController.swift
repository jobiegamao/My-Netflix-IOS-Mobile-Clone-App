//
//  SearchResultsViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/25/23.
//

import UIKit

// for when cell is tapped
protocol SearchResultsViewControllerDelagate: AnyObject {
	func searchResultsViewControllerDidTapCell(_ viewModel: FilmDetailsViewModel, model: Film)
}

class SearchResultsViewController: UIViewController {

	var films: [Film] = [Film]()
	
	weak var delegate: SearchResultsViewControllerDelagate?
	
	let resultsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 150, height: 200)
		layout.minimumInteritemSpacing = 0.5
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
		
		return collectionView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		resultsCollectionView.dataSource = self
		resultsCollectionView.delegate = self
		view.addSubview(resultsCollectionView)
		

    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		resultsCollectionView.frame = view.safeAreaLayoutGuide.layoutFrame
		
	}
	
    

    

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as? FilmCollectionViewCell else {return UICollectionViewCell() }
		
		let cellContent = films[indexPath.row]
		let cellContentTitle = cellContent.title ?? cellContent.name ?? cellContent.original_title ?? cellContent.original_name ?? "NO TITLE"
			
		cell.configure(with: FilmViewModel(title: cellContentTitle , posterURL: cellContent.poster_path ?? "" ))
		return cell
	}
	

	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return films.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		
		let selected = films[indexPath.row]
		guard let selectedTitle = selected.title ?? selected.name else {return}
		 
		APICaller.shared.getFilmYoutubeVideo(query: selectedTitle + " trailer") { [weak self] result in
			switch result{
				case .success(let ytSearchResult):
					self?.delegate?.searchResultsViewControllerDidTapCell(FilmDetailsViewModel(title: selectedTitle, ytSearchResult: ytSearchResult, genre_ids: selected.genre_ids ?? [], description: selected.overview ?? "", release_date: selected.release_date), model: selected)
				case .failure(let error):
					print(error)
					
			}
		}
		
	}

}

