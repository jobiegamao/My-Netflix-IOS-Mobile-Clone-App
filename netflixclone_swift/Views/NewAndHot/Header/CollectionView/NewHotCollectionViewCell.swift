//
//  NewHotCollectionViewCell.swift
//  netflixclone_swift
//
//  Created by may on 2/20/23.
//

import UIKit

class NewHotCollectionViewCell: UICollectionViewCell {
    
	static let identifier = "NewHotCollectionViewCell"
		
	override var isSelected: Bool {
		didSet {
			configureSelectedStatus()
		}
	}
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		

		return imageView
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
		label.textColor = .systemBackground
		label.textAlignment = .center
		label.numberOfLines = 1
		

		return label
	}()
	
	
	lazy var labelView: UIView = {
		let lv = UIView()
		lv.translatesAutoresizingMaskIntoConstraints = false
		
		
		lv.addSubview(imageView)
		lv.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: lv.leadingAnchor, constant: 5),
			imageView.bottomAnchor.constraint(equalTo: lv.bottomAnchor, constant: -5),
			imageView.widthAnchor.constraint(equalToConstant: 15),
			imageView.centerYAnchor.constraint(equalTo: lv.centerYAnchor),
			
			titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
			titleLabel.centerYAnchor.constraint(equalTo: lv.centerYAnchor),
		])
		
		return lv
	}()
	
	private lazy var indicatorView: UIView = {
		let indic = UIView()
		indic.isUserInteractionEnabled = false
		indic.translatesAutoresizingMaskIntoConstraints = false
		indic.backgroundColor = .clear
		indic.layer.masksToBounds = true 
		indic.backgroundColor = .label
		indic.layer.cornerRadius = 20
		return indic
	}()
	
	
	// MARK: - Main
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(indicatorView)
		contentView.addSubview(labelView)
		
		applyConstraints()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		configureSelectedStatus()
	}
	
	// MARK: - Public Configure Method
	public func configure(with sectionItem: Section) {
		titleLabel.text = sectionItem.title
		imageView.image = UIImage(named: sectionItem.icon)
	}
	
	// MARK: - Private Methods
	private func configureSelectedStatus(){
		if isSelected {
			indicatorView.backgroundColor = .label
			titleLabel.textColor = .systemBackground
		} else {
			indicatorView.backgroundColor = .clear
			titleLabel.textColor = .label
		}
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
		   labelView.topAnchor.constraint(equalTo: contentView.topAnchor),
		   labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		   labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
		   labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
		])
			   
	   NSLayoutConstraint.activate([
		   indicatorView.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
		   indicatorView.heightAnchor.constraint(equalToConstant: 40),
		   indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
		   indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
	   ])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

