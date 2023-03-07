//
//  Top10TableViewCell.swift
//  netflixclone_swift
//
//  Created by may on 2/21/23.
//

import UIKit
import WebKit

class Top10TableViewCell: UITableViewCell {

	static let identifier = "Top10TableViewCell"
	
	private let reusable = NewHotReusableViews()
	private lazy var webView = reusable.webView
	private lazy var placeholderImageView = reusable.placeholderImageView
	private lazy var tabView = reusable.tabView
	private lazy var titleLabel = reusable.titleLabel
	private lazy var genreLabel = reusable.genreLabel
	private lazy var descriptionLabel = reusable.descriptionLabel
	private lazy var leftLabel = reusable.leftLabel
	
	private lazy var leftView: UIView = {
		let lv = UIView()
		lv.translatesAutoresizingMaskIntoConstraints = false

		let text1 = leftLabel
		lv.addSubview(text1)

		NSLayoutConstraint.activate([
			text1.topAnchor.constraint(equalTo: lv.topAnchor),
			text1.centerXAnchor.constraint(equalTo: lv.centerXAnchor),
		])

		return lv
	}()
	
	private let btn1 = ShareButton()
	private let btn2 = MyListButton()
	private let btn3 = PlaySmallButton()
	
	// MARK: - Main
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(leftView)
		contentView.addSubview(webView)
		contentView.addSubview(placeholderImageView)
		contentView.addSubview(tabView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(genreLabel)
		
		applyConstraints()
		
	}
	
	// MARK: - Public Configure Method
	public func configureDetails(with model: Film, top position: Int){
		configureTabView(model: model)
		
		let selectedTitle = model.name ?? model.title ?? model.original_title ?? model.original_name ?? "No Title"
		
		reusable.setWebViewRequest(selectedTitle: selectedTitle, model: model)
		
		leftLabel.text = String(position)
		titleLabel.text = selectedTitle
		descriptionLabel.text = model.overview
		
		if let genres_id = model.genre_ids{
			GlobalMethods.shared.getGenresFromAPI(genres_id: genres_id ) { [weak self] stringResult in
				DispatchQueue.main.async {
					self?.genreLabel.text = stringResult
			}
		}}
		

	}
	
	func configureTabView(model: Film){
		btn1.filmModel = model
		
		btn2.filmModel = model
		
		btn3.filmModel = model
		
		tabView.buttons = [
			btn1, btn2, btn3
		]
		
	}
	
	// MARK: - Private Methods
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			leftView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			leftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			leftView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
			leftView.widthAnchor.constraint(equalToConstant: 50),
			
			webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			webView.leftAnchor.constraint(equalTo: leftView.rightAnchor, constant: 5),
			webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			webView.heightAnchor.constraint(equalToConstant: 150),
			
			placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			placeholderImageView.leftAnchor.constraint(equalTo: leftView.rightAnchor, constant: 5),
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

	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

