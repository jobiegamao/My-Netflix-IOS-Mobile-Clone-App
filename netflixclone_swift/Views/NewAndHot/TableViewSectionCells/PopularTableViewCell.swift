//
//  PopularTableViewCell.swift
//  netflixclone_swift
//
//  Created by may on 2/21/23.
//

import UIKit
import WebKit

class PopularTableViewCell: UITableViewCell {

	static let identifier = "PopularTableViewCell"
	
	private let reusable = NewHotReusableViews()
	private lazy var webView = reusable.webView
	private lazy var placeholderImageView = reusable.placeholderImageView
	private lazy var tabView = reusable.tabView
	private lazy var titleLabel = reusable.titleLabel
	private lazy var genreLabel = reusable.genreLabel
	private lazy var descriptionLabel = reusable.descriptionLabel
	

	
	private func configureTabView(model: Film){
		
		let btn1 = ShareButton()
		btn1.filmModel = model
		let btn2 = MyListButton()
		btn2.filmModel = model
		let btn3 = PlaySmallButton()
		btn3.filmModel = model
		
		tabView.buttons = [
			btn1, btn2, btn3
		]
	}
	
	public func configureDetails(with model: Film){
		
		configureTabView(model: model)
		
		guard let selectedTitle = model.name ?? model.title ?? model.original_title ?? model.original_name else {return}
		reusable.setWebViewRequest(selectedTitle: selectedTitle, model: model)
		
		titleLabel.text = selectedTitle
		descriptionLabel.text = model.overview
		
		if let genres_id = model.genre_ids{
			GlobalMethods.shared.getGenresFromAPI(genres_id: genres_id ) { [weak self] stringResult in
				DispatchQueue.main.async {
					self?.genreLabel.text = stringResult
			}
		}}
		
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			webView.heightAnchor.constraint(equalToConstant: 150),
			
			placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			placeholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			placeholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			placeholderImageView.heightAnchor.constraint(equalToConstant: 150),
			
			tabView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
			tabView.leftAnchor.constraint(equalTo: webView.leftAnchor),
			tabView.rightAnchor.constraint(equalTo: webView.rightAnchor),
			tabView.heightAnchor.constraint(equalToConstant: 50),
			
			titleLabel.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 20),
			titleLabel.leftAnchor.constraint(equalTo: webView.leftAnchor),
			titleLabel.rightAnchor.constraint(equalTo: webView.rightAnchor),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
			descriptionLabel.leftAnchor.constraint(equalTo: webView.leftAnchor),
			descriptionLabel.rightAnchor.constraint(equalTo: webView.rightAnchor),
			
			genreLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
			genreLabel.leftAnchor.constraint(equalTo: webView.leftAnchor),
			genreLabel.rightAnchor.constraint(equalTo: webView.rightAnchor),
			
		])
	}

	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(webView)
		contentView.addSubview(placeholderImageView)
		contentView.addSubview(tabView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(genreLabel)
		
		applyConstraints()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

