//
//  FilmTableViewCell.swift
//  netflixclone_swift
//
//  Created by may on 1/21/23.
// old upcoming table cell

import UIKit

class FilmTableViewCell: UITableViewCell {

	static let identifier = "FilmTableViewCell"
	
	private let filmPosterImageView = PosterImageView()

	private let filmPosterLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		return label
	}()
	
	private let playFilmBtn: UIButton = {
		let button = UIButton()
		let icon = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .light))
		button.setImage(icon, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.tintColor = .label
		return button
	}()
	
	private func applyConstraints(){
		NSLayoutConstraint.activate( [
			filmPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			filmPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
			filmPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
			filmPosterImageView.widthAnchor.constraint(equalToConstant: 100),
		
			filmPosterLabel.leadingAnchor.constraint(equalTo: filmPosterImageView.trailingAnchor, constant: 15),
			filmPosterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			filmPosterLabel.widthAnchor.constraint(equalToConstant: 190),
			
	
			playFilmBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			playFilmBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
		])
	}
	
	public func configure(with model: FilmViewModel){
		guard let url = URL(string: posterBaseURL + model.posterURL) else {return}
		filmPosterImageView.sd_setImage(with: url)
		filmPosterLabel.text = model.title
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(filmPosterImageView)
		contentView.addSubview(filmPosterLabel)
		contentView.addSubview(playFilmBtn)
		
		applyConstraints()
	}
	
	 
	required init?(coder: NSCoder) {
		fatalError()
	}
}
