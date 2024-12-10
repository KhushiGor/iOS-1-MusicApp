
import UIKit
import CoreData
class SavedSongsTableViewController: UITableViewController {

    var savedSongs = [SongEntity]()// This will hold the saved songs from Core Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch saved songs when the view is loaded
        fetchSavedSongs()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(clearAllSongs))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
               tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func clearAllSongs() {
           // Call CoreDataManager's deleteAllData to delete all songs from Core Data
           CoreDataManager.shared.deleteAllData()
           
           // After deletion, refresh the saved songs list
           fetchSavedSongs()
           
           // Optionally, show a confirmation message
           let alert = UIAlertController(title: "Deleted", message: "All songs have been deleted.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    // Long tap gesture handler
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            let location = gesture.location(in: tableView)
            
            if gesture.state == .began {
                if let indexPath = tableView.indexPathForRow(at: location) {
                    let songToDelete = savedSongs[indexPath.row]
                    
                    // Show alert to confirm deletion
                    let alert = UIAlertController(title: "Delete Song", message: "Are you sure you want to delete this song?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                        self.deleteSong(song: songToDelete)
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }

        // Delete song from Core Data
        func deleteSong(song: SongEntity) {
            CoreDataManager.shared.context.delete(song)
            
            do {
                try CoreDataManager.shared.context.save()
                // Remove the song from the array and update the table view
                if let index = savedSongs.firstIndex(of: song) {
                    savedSongs.remove(at: index)
                    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            } catch {
                print("Failed to delete song: \(error.localizedDescription)")
            }
        }
        
    // Fetch saved songs from Core Data
    func fetchSavedSongs() {
        if let songs = CoreDataManager.shared.fetchSongs() {
            savedSongs = songs
            tableView.reloadData() // Reload the table view with saved songs
        }
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSongs.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = savedSongs[indexPath.row]
        performSegue(withIdentifier: "showSavedSongDetails", sender: selectedSong)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSavedSongDetails" {
            if let songDetailVC = segue.destination as? SongDetailsViewController,
               let selectedSong = sender as? Song {
                songDetailVC.song = selectedSong
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedSongCell", for: indexPath)
        
        let song = savedSongs[indexPath.row]
        
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artist
        if let url = URL(string: song.thumbnailURL ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }
}
