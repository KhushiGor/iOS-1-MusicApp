import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    // Access the context (make sure it's passed or accessible here)
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       // Fetch songs from Core Data
    // Fetch songs from Core Data
        func fetchSongs() -> [SongEntity]? {
            // Use the correct fetch request for SongEntity
            let fetchRequest: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
            
            do {
                let songs = try context.fetch(fetchRequest)
                return songs
            } catch {
                print("Failed to fetch songs: \(error)")
                return nil
            }
        }
        
       
       // Save songs to Core Data
       func saveSongs(songs: [Song]) {
           for song in songs {
               let songEntity = SongEntity(context: context) // Correct entity name is SongEntity
               songEntity.id = song.id
               songEntity.name = song.name
               songEntity.artist = song.artist
               songEntity.thumbnailURL = song.thumbnailURL
           }
           
           do {
               try context.save()
           } catch {
               print("Failed to save songs: \(error)")
           }
       }
   }
