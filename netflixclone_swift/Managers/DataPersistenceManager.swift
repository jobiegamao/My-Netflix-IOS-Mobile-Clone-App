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
		case failedToSaveData, failedToFetchDatabase, failedToDeleteFromDatabase, invalidData
	}
	
	
	func saveAsFilmItem(model: Film, completion: @escaping(Result<Void, Error>) -> Void) {

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let userProfile = AppSettings.selectedProfile
		else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		//create a query, check if exists
		let fetchRequest = NSFetchRequest<FilmItem>(entityName: "FilmItem")
		fetchRequest.predicate = NSPredicate(format: "film_id == %ld AND userProfile_id == %@", model.id, userProfile.id)
		
		do{
			// query request
			let results = try context.fetch(fetchRequest)
			
			// If no result, film is not saved in FilmItem, save it
			if results.count == 0 {
				let item = FilmItem(context: context)
				
				item.film_id = Int64(model.id)
				item.title = model.title
				item.original_title = model.original_title
				item.name = model.name
				item.original_name = model.original_name
				item.overview = model.overview
				item.media_type = model.media_type
				item.poster_path = model.poster_path
				item.genre_ids = model.genre_ids
				item.release_date = model.release_date
				item.backdrop_path = model.backdrop_path
				
				item.downloaded_date = Date()
				item.userProfile_id = userProfile.id
				
				try context.save()
			}
			completion(.success(()))
			
		} catch {
			completion(.failure(DatabaseError.failedToSaveData))
		}
	}
	
	func getFilmItemsOfProfile(completion: @escaping (Result<[FilmItem],Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let userProfile = AppSettings.selectedProfile
		else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		//create a query, check if exists
		let fetchRequest = NSFetchRequest<FilmItem>(entityName: "FilmItem")
		fetchRequest.predicate = NSPredicate(format: "userProfile_id == %@", userProfile.id)
		
		
		do {
			let result = try context.fetch(fetchRequest)
			completion(.success(result))
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
			completion(.failure(DatabaseError.failedToFetchDatabase))
		}
	}
	
	func deleteFilmItemOfProfile(model: Film, completion: @escaping (Result<Void,Error>) -> Void){
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let userProfile = AppSettings.selectedProfile
		else {return}
		let context = appDelegate.persistentContainer.viewContext
		
		//create a query, check if exists
		let fetchRequest = NSFetchRequest<FilmItem>(entityName: "FilmItem")
		fetchRequest.predicate = NSPredicate(format: "film_id == %ld AND userProfile_id == %@", model.id, userProfile.id)
			
		
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
	
}


/*
 
 private func saveFilmItem(model: Film) {
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
			 item.backdrop_path = model.backdrop_path
			 
			 try context.save()
		 }
	 } catch let error as NSError {
		 print("Could not fetch. \(error), \(error.userInfo)")
	 }
	 
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
 
 //result should be an filmitem in database file  coredata
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

 */
