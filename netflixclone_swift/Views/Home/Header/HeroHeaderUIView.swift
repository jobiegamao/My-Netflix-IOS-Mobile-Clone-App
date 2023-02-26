//
//  HeroHeaderUIView.swift
//  netflixclone_swift
//
//  Created by may on 1/14/23.
//

import UIKit

class HeroHeaderUIView: UIView {

	
	private var film: Film? {
		didSet{
			mylistBtn.filmModel = film
			infoBtn.filmModel = film
		}
	}

	private var heroImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let heroLabel: UILabel = {
		var heroInfo = ["Dark", "Exciting", "Anime Movies"]
		let label = UILabel()
		label.text = heroInfo.joined(separator: " \u{2022} ")
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var mylistBtn: MyListButton = {
		let btn = MyListButton()
		btn.iconImageView.transform = btn.iconImageView.transform.scaledBy(x: 0.9, y: 0.9)
		return btn
	}()
	

	
	private let playBtn: UIButton = {
		var btnConfig = UIButton.Configuration.filled()
		btnConfig.title = "Play"
		btnConfig.image = UIImage(systemName: "play.fill")
		btnConfig.imagePlacement = .leading
		btnConfig.baseBackgroundColor = .white
		btnConfig.baseForegroundColor = .black
		btnConfig.imagePadding = 10
	
		let btn = UIButton(configuration: btnConfig)
		btn.layer.cornerRadius = 1
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()
	
	private lazy var infoBtn: InfoButton = {
		let btn = InfoButton()
		return btn
	}()
	
	private let gradientLayer: CAGradientLayer = {
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [
			UIColor.black.cgColor,
			UIColor.clear.cgColor,
			UIColor.black.cgColor,
		]
		return gradientLayer
	}()
	
	private let gradientLayerBehind: CAGradientLayer = {
		let gradientLayer = CAGradientLayer()
		return gradientLayer
	}()
	
	private func addGradientBehind(image: UIImage, gradientLayer: CAGradientLayer){
		guard let colors = image.getColors() else {return}
		
		gradientLayer.colors = [
			colors.background.cgColor,
			colors.primary.cgColor,
			colors.secondary.cgColor,
			colors.detail.cgColor
		]
		
		layer.insertSublayer(gradientLayer, at: 0)
	}
	
	func configureHeroHeaderView(){
		APICaller.shared.getTrending(media_type: MediaType.all.rawValue, time_period: "day") { [weak self] results in
			
			switch results {
				case .success(let films):
					let heroFeaturedFilm = films.randomElement()
					self?.film = heroFeaturedFilm
					guard let poster_path = heroFeaturedFilm?.poster_path else { return }
					
								
					self?.heroImageView.sd_setImage(with: URL(string: posterBaseURL + poster_path), completed: { (image, _, _, _ ) in
						guard let image = image else { return }
						self?.addGradientBehind(image: image, gradientLayer: self?.gradientLayerBehind ?? CAGradientLayer())
					})
			
					// add genre text label
					guard let genres_id = heroFeaturedFilm?.genre_ids else {return}
					self?.getGenresFromAPI(genres_id: genres_id)
					
								
				case .failure(let error):
					print(error)
			}
		}
		
	}
	
	private func getGenresFromAPI(genres_id: [Int]){
		APICaller.shared.getGenreNames { [weak self] result in
			switch result {
				case .success(let genreDict):
					var names = [String]()
					for id in genres_id{
						names.append(genreDict[id] ?? "")
					}
					DispatchQueue.main.async {
						self?.heroLabel.text = names.joined(separator: " \u{2022} ")
					}
			
				case .failure(let failure):
					print(failure)
			}
		}
	
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			heroLabel.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -15),
			heroLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			playBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			playBtn.widthAnchor.constraint(equalToConstant: 100),
			playBtn.heightAnchor.constraint(equalToConstant:30),
			playBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
			
			mylistBtn.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: -30),
			mylistBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor),
			
			infoBtn.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 30),
			infoBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor),
			
		])
		

	}
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layer.addSublayer(gradientLayerBehind)
		addSubview(heroImageView)
		configureHeroHeaderView()
		
		layer.addSublayer(gradientLayer)
		addSubview(heroLabel)
		
		addSubview(mylistBtn)
		addSubview(playBtn)
		addSubview(infoBtn)
		
		applyConstraints()
		
		
		
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		heroImageView.frame = bounds
		gradientLayer.frame = bounds
		gradientLayerBehind.frame = bounds
	}
	
	
	
	
	required init?(coder: NSCoder) {
		fatalError()
	}
}


