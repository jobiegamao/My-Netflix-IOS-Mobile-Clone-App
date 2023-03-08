//
//  SearchResultsViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/25/23.
//

import UIKit

// for when cell is tapped
protocol SearchResultsViewControllerDelagate: AnyObject {
	func searchResultsViewControllerDidTapCell(model: Film)
}

class SearchResultsViewController: UIViewController {

	var films: [Film] = [Film]()
	
	weak var delegate: SearchResultsViewControllerDelagate?
	
	let resultsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
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

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	
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
		 
		let vc = FilmDetailsViewController()
		vc.configure(model: selected)
		present(vc, animated: true)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		var spacing = 0.5
		if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
			spacing = layout.minimumInteritemSpacing
		}
		
		// Calculate the available width by subtracting the minimum spacing from the view width
		let availableWidth = collectionView.frame.width - spacing

		// Calculate the item width by dividing the available width by the number of items that can fit (use a minimum width of 100)
		let itemWidth = max(100, floor(availableWidth / CGFloat(floor(availableWidth / 100))))

		// Calculate the item height based on the item width (use a minimum height of 100)
		let itemHeight = max(100, floor(itemWidth * 1.5))

		// Return the calculated size
		return CGSize(width: itemWidth, height: itemHeight)
	}

}

