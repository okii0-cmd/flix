//
//  MoviesViewController.swift
//  flix
//
//  Created by okii on 18/9/21.
//

import UIKit
import AlamofireImage

class MoviesViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        cell.titleLabel!.text = title
        cell.synopsisLabel!.text = synopsis
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl+posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movies = [[String:Any]]() // creation of array of dictionary of Any type , () to indicate a new array
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //stuff to do after setup
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String:Any]]// movies now contain all the data from the API collected
                self.tableView.reloadData()
                
                
                
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue,sender:Any?){
        
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!// table view knows the indexpath tapped on
        let movie = movies[indexPath.row]
        
        // the sender is the cell that is tapped on
        //Find the selected movie
        //pass the selected move to the details view controller
        let  detailsViewController = segue.destination as! MovieDetailsViewController // segue gives the generic view controller, we want it to use the MovieDetails one
        detailsViewController.movie = movie // pass the movie into the intialized movie variable in details view controller
         
         
    }

}

