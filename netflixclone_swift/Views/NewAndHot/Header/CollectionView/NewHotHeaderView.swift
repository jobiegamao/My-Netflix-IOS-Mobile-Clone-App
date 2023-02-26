//
//  N&HHeaderView.swift
//  netflixclone_swift
//
//  Created by may on 2/20/23.
//

import UIKit

struct Section {
	let title: String
	let icon: String
}


class NewHotHeaderView: UIView {

	var sectionItems: [Section] = []
	var didSelectSection: ((Int) -> Void)?
	var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0){
		didSet{
			sectionCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
		}
	}
	
	
	public lazy var sectionCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal

		
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.register(NewHotCollectionViewCell.self, forCellWithReuseIdentifier: NewHotCollectionViewCell.identifier)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.backgroundColor = .clear
		cv.showsHorizontalScrollIndicator = false
		cv.alwaysBounceHorizontal = true
		
		cv.delegate = self
		cv.dataSource = self

		return cv
	}()
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.addSubview(sectionCollectionView)
		NSLayoutConstraint.activate([
			sectionCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			sectionCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
			sectionCollectionView.topAnchor.constraint(equalTo: topAnchor),
			sectionCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
	   ])
		
		
	}
	

	override func layoutSubviews() {
		super.layoutSubviews()
		sectionCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}



extension NewHotHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sectionItems.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewHotCollectionViewCell.identifier, for: indexPath) as? NewHotCollectionViewCell else{ return UICollectionViewCell() }
		let sectionItem = sectionItems[indexPath.row]
		cell.configure(with: sectionItem)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		didSelectSection?(indexPath.row)
		selectedIndexPath = indexPath
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let title = sectionItems[indexPath.row].title
		let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17, weight: .heavy)]).width + 30
		return CGSize(width: width, height: collectionView.frame.height)
	}
	
	
	
}

