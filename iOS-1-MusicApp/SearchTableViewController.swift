//
//  SearchTableViewController.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
//    var apiSongs = [String]()
    var searchTask: DispatchWorkItem?
    var songs = [Song]()
        
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        print(searchText)
        
        searchTask?.cancel()
        if searchText.count > 2{
           
            let task = DispatchWorkItem { [weak self] in
                      self?.searchSongsfromAPI(query: searchText)
                  }
                  searchTask = task

                  // Execute the task after a short delay (e.g., 300ms)
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
              }
                
            
        else {
            
            tableView.reloadData()
            
        }
    }
    
    func searchSongsfromAPI(query: String) {
            SpotifyAPI.shared.searchSongs(query: query) { [weak self] result in
                switch result {
                case .success(let songs):
                    self?.songs = songs
                    
                    // Save fetched songs to Core Data
                    CoreDataManager.shared.saveSongs(songs: songs)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("Failed to fetch songs: \(error.localizedDescription)")
                }
            }
        }    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    func networkingDidFinishWithListOfSongs(songs: [String]) {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
//    func networkingDidFail() {
//        
//    }
//    
//    func networkingDidFinishWithSongObj(so: SongInfo) {
//        
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
                
        cell.textLabel?.text = song.name
               cell.detailTextLabel?.text = song.artist
               if let url = URL(string: song.thumbnailURL) {
                   // Load the thumbnail image asynchronously (optional)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = songs[indexPath.row]
        
        // Navigate to SongDetailsViewController
        if let songDetailsVC = storyboard?.instantiateViewController(withIdentifier: "SongDetailsViewController") as? SongDetailsViewController {
            songDetailsVC.song = selectedSong // Pass the selected song to the SongDetailsViewController
            navigationController?.pushViewController(songDetailsVC, animated: true)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showSongDetails" {  // Make sure the segue identifier is correct
//            if let songdetailVC = segue.destination as? SongDetailsViewController {
//                if let selectedRow = tableView.indexPathForSelectedRow?.row {
//                    songdetailVC.selectedSong = songs[selectedRow]
//                }
//            }
//        }
//    }

}
//extension UIImageView {
//    func loadImage(from urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            if let data = data, error == nil {
//                DispatchQueue.main.async {
//                    self?.image = UIImage(data: data)
//                }
//            }
//        }.resume()
//    }
//}
