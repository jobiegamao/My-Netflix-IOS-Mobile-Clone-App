//
//  ActionsTableViewCell.swift
//  netflixclone_swift
//
//  Created by may on 3/8/23.
//

import UIKit

class ActionsTableViewCell: UITableViewCell {
	
	static let identifier = "ActionsTableViewCell"
	
	private lazy var cellView: ButtonImageAndText = {
		let btn = ButtonImageAndText(text: "", image: nil, iconPlacement: .left)
//		btn.iconImageView.transform = btn.iconImageView.transform.scaledBy(x: 1.5, y: 1.5)
		btn.label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		btn.isUserInteractionEnabled = false
		return btn
	}()

	
	// MARK: - Main
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(cellView)
		
		accessoryType = .disclosureIndicator
		applyConstraints()
	}
	
	
	// MARK: - Public Configure Method
	public func configureCell(with model: Section){
		cellView.iconImageView.image = UIImage(systemName: model.icon)
		cellView.label.text = model.title
	}
	
	// MARK: - Private Methods
	private func applyConstraints(){
		NSLayoutConstraint.activate( [
			cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
			cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
		
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
