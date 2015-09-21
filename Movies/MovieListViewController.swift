//
//  MovieListViewController.swift
//  Movies
//
//  Created by Nikrad Mahdi on 9/13/15.
//  Copyright (c) 2015 Nikrad. All rights reserved.
//

import UIKit
import AFNetworking

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var refreshControl: UIRefreshControl!
  var progressView: SpotifyProgressHUD!
  var networkErrorView: UIView!
  
  var movieList: [Movie]!
  var filteredMovieList: [Movie]!
  var dataURL: NSURL!
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    searchBar.resignFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self

    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    networkErrorView = UIView(frame: CGRect(x: 0, y: 64, width: 320, height: 50))
    networkErrorView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
    let networkErrorLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 320, height: 40))
    networkErrorLabel.text = "You're currently offline"
    networkErrorLabel.textColor = UIColor.whiteColor()
    networkErrorLabel.textAlignment = .Center
    networkErrorView.addSubview(networkErrorLabel)
    view.addSubview(networkErrorView)
    networkErrorView.hidden = true
    
    progressView = SpotifyProgressHUD(frame: CGRect(x: 0, y: 0, width: 150, height: 150), withPointDiameter: 16, withInterval: 0.25)
    progressView.center = view.center
    view.addSubview(progressView)

    loadMovies() {
      self.progressView.hidden = true
    }
  }

  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let moviesList = self.filteredMovieList {
      return moviesList.count
    }
    else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MoviesListTableViewCell
    let movie = self.filteredMovieList![indexPath.row]
    cell.titleLabel.text = movie.title
    cell.synopsisLabel.text = movie.synopsis
    cell.posterImage.setImageWithURLRequest(NSURLRequest(URL: movie.posterURL), placeholderImage: nil, success: { (request, response, image) -> Void in
        cell.posterImage.image = image
        cell.posterImage.alpha = 0.0
        UIView.animateWithDuration(0.5) {
          cell.posterImage.alpha = 1.0
        }
      }, failure: nil)
//    cell.posterImage.setImageWithURL(movie.posterURL)
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 120
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filteredMovieList = searchText.isEmpty ? movieList : movieList.filter({(movie: Movie) -> Bool in
      return movie.title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
    })
    
    tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.showsCancelButton = false
    searchBar.resignFirstResponder()
    filteredMovieList = movieList
    tableView.reloadData()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let vc = segue.destinationViewController as! MovieDetailsViewController
    let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
    vc.movie = filteredMovieList[indexPath.row]
  }

  func onRefresh(sender: AnyObject?) {
    networkErrorView.hidden = true
    loadMovies() {
      self.refreshControl.endRefreshing()
    }
  }

  func loadMovies(onCompletion: (() -> ())? = nil) {
    let request = NSURLRequest(URL: dataURL)
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) -> Void in
      dispatch_async(dispatch_get_main_queue()) {
        if error != nil {
          if error?.code == -1009 {
            self.networkErrorView.hidden = false
            self.refreshControl.endRefreshing()
            self.progressView.removeFromSuperview()
          }
        } else {
          // Add a one second delay so the user can see the pretty loading state :)
          self.delay(1) {
            self.networkErrorView.hidden = true
            let responseData = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            var movies: Array<Movie> = []
            for movie in responseData["movies"] as! Array<AnyObject> {
              movies.append(Movie(movieData: movie as! NSDictionary))
            }
            self.movieList = movies
            self.filteredMovieList = movies
            self.tableView.reloadData()
            onCompletion?()
          }
        }
      }
    }
    task.resume()
  }

}

