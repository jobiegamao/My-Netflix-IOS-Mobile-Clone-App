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
	
	func configure(with model: FilmViewModel){
		guard let url = URL(string: posterBaseURL + model.posterURL) else {
			print("error: FilmCollectionViewCell, configure()")
			return
		}
		posterImageView.sd_setImage(with: url)
		NSLayoutConstraint.activate([
			posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			posterImageView.topAnchor.constraint(equalTo: topAnchor),
			posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	// MARK: Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(posterImageView)
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	
}

