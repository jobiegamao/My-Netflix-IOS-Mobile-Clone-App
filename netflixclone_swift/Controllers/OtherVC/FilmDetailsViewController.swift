//
//  FilmDetailsViewController.swift
//  netflixclone_swift
//
//  Created by may on 1/26/23.
//

import UIKit
import WebKit

class FilmDetailsViewController: UIViewController, UIScrollViewDelegate {
	
	private var model: Film?
	
	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.alwaysBounceVertical = true
		
		return scrollView
	}()
	
	private let webView: WKWebView = {
		let webview = WKWebView()
		webview.translatesAutoresizingMaskIntoConstraints = false
		webview.layer.cornerRadius = 10.0
		webview.layer.masksToBounds = true
		return webview
	}()
	
	private lazy var placeholderImageView: UIImageView = {
		let piv = UIImageView(frame: self.webView.frame)
		piv.translatesAutoresizingMaskIntoConstraints = false
		piv.contentMode = .scaleAspectFill
		piv.layer.cornerRadius = 10.0
		piv.layer.masksToBounds = true
		
		piv.isHidden = true
		return piv
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 22, weight: .bold)
		return label
	}()
	
	private let genreLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 20, weight: .ultraLight)
		label.numberOfLines = 0
		return label
	}()
	
	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 18)
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var downloadBtn: UIButton = {
		let btn = UIButton()
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.backgroundColor = .red
		btn.setTitleColor(.white, for: .normal)
		btn.setTitle("Download", for: .normal)
		btn.layer.cornerRadius = 5
		btn.clipsToBounds = true
		btn.layer.masksToBounds = true
		btn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
		return btn
	}()
	
	@objc private func downloadAction() {
		guard let FilmModel = self.model else {return}
		DataPersistenceManager.shared.downloadFilm(model: FilmModel) { result in
			switch result {
				case .success():
					NotificationCenter.default.post(Notification(name: NSNotification.Name("downloaded")))
				case .failure(let error):
					print(error, "HomeTableViewCell, downloadAction() ")
			}
		}
	}
	
	
	public func configure(model: Film) {
		self.model = model
		
		let selectedTitle = model.name ?? model.title ?? model.original_title ?? model.original_name ?? "No Title"
		
		GlobalMethods.shared.getYtVidURL(model: model) { [weak self] result in
			switch result{
				case .success(let url):
					let request = URLRequest(url: url)
					DispatchQueue.main.async {
						self?.webView.load(request)
					}
				case .failure(_):
					DispatchQueue.main.async {
						self?.webView.isHidden = true
						self?.placeholderImageView.isHidden = false
					}
					
					guard let backdrop_path = model.backdrop_path else {return}
					let url = URL(string: posterBaseURL + backdrop_path)
					self?.placeholderImageView.sd_setImage(with: url)
			}
		}
		
		// Update the rest of the UI
		titleLabel.text = selectedTitle
		descriptionLabel.text = model.overview
		
		if let genres_id = model.genre_ids{
			GlobalMethods.shared.getGenresFromAPI(genres_id: genres_id ) { [weak self] stringResult in
				DispatchQueue.main.async {
					self?.genreLabel.text = stringResult
				}
			}
		}
	}
	
	private func configureConstraints(){
		let view = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			webView.topAnchor.constraint(equalTo: view.topAnchor),
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			webView.heightAnchor.constraint(equalToConstant: 250),
			
			placeholderImageView.topAnchor.constraint(equalTo: webView.topAnchor),
			placeholderImageView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
			placeholderImageView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
			placeholderImageView.bottomAnchor.constraint(equalTo: webView.bottomAnchor),
			
			
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: webView.bottomAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			
			genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			
			descriptionLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
			descriptionLabel.leadingAnchor.constraint(equalTo: genreLabel.leadingAnchor),
			descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			
			downloadBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
			downloadBtn.widthAnchor.constraint(equalToConstant: 140),
			downloadBtn.heightAnchor.constraint(equalToConstant: 40),
			downloadBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			downloadBtn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
			
			
		])
		
		 
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
		view.addSubview(webView)
		view.addSubview(placeholderImageView)
		view.addSubview(scrollView)
		scrollView.addSubview(titleLabel)
		scrollView.addSubview(genreLabel)
		scrollView.addSubview(descriptionLabel)
		scrollView.addSubview(downloadBtn)
		
		
		configureConstraints()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		scrollView.contentSize = CGSize(width: view.bounds.width, height: scrollView.bounds.height + 100)
		
	}
	
    

    

}


