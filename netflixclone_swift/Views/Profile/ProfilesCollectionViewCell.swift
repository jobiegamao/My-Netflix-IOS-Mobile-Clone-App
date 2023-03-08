//
//  ProfilesCollectionView.swift
//  netflixclone_swift
//
//  Created by may on 2/27/23.
//

import UIKit


class ProfilesCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "ProfilesCollectionViewCell"
	
	private lazy var profileBtn = {
		let btn = ButtonImageAndText(text: "hello", image: UIImage(systemName: "person"), iconPlacement: .top)
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(profileBtn)
		applyConstraints()
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			profileBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			profileBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			profileBtn.topAnchor.constraint(equalTo: contentView.topAnchor),
			profileBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
	
	func configureProfileCellData(model: UserProfile){
		profileBtn.iconImageView.image = UIImage(named: "profileicon")
		profileBtn.label.text = model.userProfileName
		
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
