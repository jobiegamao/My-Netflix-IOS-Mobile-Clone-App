//
//  posterImageView.swift
//  netflixclone_swift
//
//  Created by may on 2/20/23.
//

import UIKit

class PosterImageView: UIImageView {

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		contentMode = .scaleAspectFill
		translatesAutoresizingMaskIntoConstraints = false
		clipsToBounds = true
		layer.masksToBounds = true
		layer.cornerRadius = 5
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
