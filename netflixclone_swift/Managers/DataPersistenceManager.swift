//
//  DataPersistenceManager.swift
//  netflixclone_swift
//
//  Created by may on 1/30/23.
// 	to communicate with CORE DATA File

import Foundation
import CoreData
import UIKit

class DataPersistenceManager {
	
	static let shared = DataPersistenceManager()
	
	enum DatabaseError: Error {
		case failedToSaveData, failedToFetchDatabase, failedToDeleteFromDatabase
	}
	
	func getFilmItem(with id: Int) -> FilmItem? {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let filmItemFetchRequest = NSFetchRequest<FilmItem>(entityName: "FilmItem")
		filmItemFetchRequest.predicate = NSPredicate(format: "id == %d", id)

		
		do{
			let film = try context.fetch(filmItemFetchRequest).first
			return film
		}catch{
			print("error in getting filmItem")
		}
		
		return nil
	}
	
	func saveFilmItem(model: Film) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		// Check if film is already saved in FilmItem
		let fetchRequest = NSFetchRequest<FilmItem>(entityName: "FilmItem")
		fetchRequest.predicate = NSPredicate(format: "id == %d", model.id)
		
		do {
			let results = try context.fetch(fetchRequest)
			
			// If film is not saved in FilmItem, save it
			if results.count == 0 {
				let item = FilmItem(context: context)
				
				item.id = Int64(model.id)
				item.title = model.title
				item.original_title = model.original_title
				item.name = model.name
				item.original_name = model.original_name
				item.overview = model.overview
				item.media_type = model.media_type
				item.poster_path = model.poster_path
				item.genre_ids = model.genre_ids
				item.release_date = model.release_date
				
				try context.save()
			}
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
	}
	
	func downloadFilm(model: Film, completion: @escaping(Result<Void, Error>) -> Void) {
		 
		saveFilmItem(model: model)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<DownloadedFilms>(entityName: "DownloadedFilms")
		// if model.id == DownloadedFilms.film.id then its already downloaded
		fetchRequest.predicate = NSPredicate(format: "film.id == %ld", model.id)
		
		do{
			let downloadedFilms = try context.fetch(fetchRequest)
			if downloadedFilms.isEmpty {
				// Film has not been downloaded yet, so proceed with the download process
				if let film = getFilmItem(with: model.id){
					let db = DownloadedFilms(context: context)
					db.film = film
					db.downloadedDate = Date()
					
					try context.save()
				}
				
			} else {
				// Film has already been downloaded, so do nothing
				print("Film already downloaded.")
			}
			completion(.success(()))
			
		} catch {
			print(error, "DataPersistenceManager, context.save()")
			completion(.failure(DatabaseError.failedToSaveData))
			
		}
	
		
	}
	
	func addToListFilm(model: Film, completion: @escaping(Result<Void, Error>) -> Void) {
		 
		saveFilmItem(model: model)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<MyListFilms>(entityName: "MyListFilms")
		fetchRequest.predicate = NSPredicate(format: "film.id == %ld", model.id)
		
		do{
			let dbCollection = try context.fetch(fetchRequest)
			if dbCollection.isEmpty {
				if let film = getFilmItem(with: model.id){
					let db = MyListFilms(context: context)
					db.film = film
					db.added_date = Date()
					
					try context.save()
				}
				
			} else {
				print("duplicate")
			}
			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToSaveData))
		}
	
		
	}
	
	func addToReminderFilm(model: Film, completion: @escaping(Result<Void, Error>) -> Void) {
		 
		saveFilmItem(model: model)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<RemindMeFilms>(entityName: "RemindMeFilms")
		fetchRequest.predicate = NSPredicate(format: "film.id == %ld", model.id)
		
		do{
			let dbCollection = try context.fetch(fetchRequest)
			if dbCollection.isEmpty {
				if let film = getFilmItem(with: model.id){
					let db = RemindMeFilms(context: context)
					db.film = film
					db.hadReleased = true
					
					try context.save()
				}
				
			} else {
				print("duplicate")
			}
			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToSaveData))
		}
	
		
	}
	
	
	
	
	//result should be an item in database file  coredata
	func fetchFilmsFromDatabase(completion: @escaping (Result<[FilmItem],Error>) -> Void) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
	
		do{
			let results = try context.fetch(FilmItem.fetchRequest())
			completion(.success(results))
		}catch{
			completion(.failure(DatabaseError.failedToFetchDatabase))
		}
	}
	
	func getDownloadedFilms(completion: @escaping (Result<[FilmItem],Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<DownloadedFilms>(entityName: "DownloadedFilms")

		
		do {
			let result = try context.fetch(fetchRequest)
			var films: [FilmItem] = []
			for film in result {
				if let filmItem = film.film{
					films.append(filmItem)
				}
			}
			completion(.success(films))
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
			completion(.failure(DatabaseError.failedToFetchDatabase))
		}
	}
	
	func deleteDownload(filmID id: Int64, completion: @escaping (Result<Void,Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<DownloadedFilms>(entityName: "DownloadedFilms")
		fetchRequest.predicate = NSPredicate(format: "film.id == %ld", id)
			
		
		do{
			let result = try context.fetch(fetchRequest).first
			if let result = result {
				context.delete(result)
				try context.save()
			}

			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToDeleteFromDatabase))
		}
	}
	
	func deleteToMyList(filmID id: Int, completion: @escaping (Result<Void,Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<MyListFilms>(entityName: "MyListFilms")
		fetchRequest.predicate = NSPredicate(format: "film.id == %ld", id)
			
		
		do{
			let result = try context.fetch(fetchRequest).first
			if let result = result {
				context.delete(result)
				try context.save()
			}

			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToDeleteFromDatabase))
		}
	}
	
	func deleteReminder(filmID id: Int, completion: @escaping (Result<Void,Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<RemindMeFilms>(entityName: "RemindMeFilms")
		fetchRequest.predicate = NSPredicate(format: "film.id == %ld", id)
			
		
		do{
			let result = try context.fetch(fetchRequest).first
			if let result = result {
				context.delete(result)
				try context.save()
			}

			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToDeleteFromDatabase))
		}
	}
	
	func deleteFilmItem(model: FilmItem, completion: @escaping (Result<Void,Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		
		let context = appDelegate.persistentContainer.viewContext
		
		context.delete(model)
		
		do{
			try context.save()
			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToDeleteFromDatabase))
		}
	}
}
