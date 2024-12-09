//
//  CoreDataManager.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-09.
//

import Foundation
import CoreData

class CoreDataManager {
   
    // ToDo app ---> CURD
    // insert new ToDo
    // update a ToDo
    // select task where -----
    // delete a task
    
    static var shared = CoreDataManager()
    
    func getAllSongsFromDB() -> [Song]{
        
        var databaseList = [Song]()
       // select * from ToDo
        var fetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
       
        do{
            databaseList =  try persistentContainer.viewContext.fetch(fetchRequest)
            print(databaseList.count)
        
        } catch {
            
            print(error)
        }
        return databaseList
    }
    
    
    
    func getSong(searchSong: String) -> [Song]{
        // select * from ToDo where task CONTAINS searchTask
        var databaseList = [Song]()
       
        var fetchRequest : NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "song CONTAINS[c] %@", searchSong)
    
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "song", ascending: true),
        ]
        do{
            databaseList =  try persistentContainer.viewContext.fetch(fetchRequest)
            print(databaseList.count)
        
        } catch {
            
            print(error)
        }
        return databaseList
    }
    
    
    
    func addNewSong(songname: String){
        
        var newSong = Song(context: persistentContainer.viewContext)
        newSong.songname = songname
        print("New song added: \(songname)")
        
        saveContext()
    }
    
    
    func deleteOneSong(todelete:Song){
        persistentContainer.viewContext.delete(todelete)
        saveContext()
    }
    
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "iOS-1-MusicApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    
}
