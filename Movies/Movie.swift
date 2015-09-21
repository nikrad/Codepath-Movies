//
//  Movie.swift
//  Movies
//
//  Created by Nikrad Mahdi on 9/19/15.
//  Copyright © 2015 Nikrad. All rights reserved.
//

import Foundation

class Movie {
  // MARK: Properties
  
  var title: String!
  var synopsis: String!
  var posterURL: NSURL!
  var rating: String!
  var criticsScore: String!
  var audienceScore: String!
  
  // MARK: Initialization
  
  init(movieData: NSDictionary) {
    title = movieData["title"] as! String
    synopsis = movieData["synopsis"] as! String
    rating = movieData["mpaa_rating"] as! String
    let criticsScoreValue = movieData.valueForKeyPath("ratings.critics_score") as! Int
    criticsScore = "\(criticsScoreValue)%"
    let audienceScoreValue = movieData.valueForKeyPath("ratings.audience_score") as! Int
    audienceScore = "\(audienceScoreValue)%"
    
    var posterLink = movieData.valueForKeyPath("posters.thumbnail") as! String
    let range = posterLink.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
    if let range = range {
      posterLink = posterLink.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
    }
    posterURL = NSURL(string: posterLink)
  }
  
}
