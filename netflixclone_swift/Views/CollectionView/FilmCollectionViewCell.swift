//
//  FilmCollectionViewCell.swift
//  netflixclone_swift
//
//  Created by may on 1/20/23.
//

import UIKit
import SDWebImage

class FilmCollectionViewCell: UICollectionViewCell {
  

	static let identifier = "FilmCollectionViewCell"
	private let posterImageView = PosterImageView()
	
	
	// MARK: - Main
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(posterImageView)
		
		NSLayoutConstraint.activate([
			posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			posterImageView.topAnchor.constraint(equalTo: topAnchor),
			posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	// MARK: - Public Configure Method
	func configure(with model: Film){
		guard let posterPath = model.poster_path, let url = URL(string: posterBaseURL + posterPath) else {
			print("error: FilmCollectionViewCell, configure()")
			return
		}
		posterImageView.sd_setImage(with: url)
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	
}

