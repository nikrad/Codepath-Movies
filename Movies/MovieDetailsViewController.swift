//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Nikrad Mahdi on 9/15/15.
//  Copyright © 2015 Nikrad. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate {

  @IBOutlet weak var foreground: UIScrollView!
  @IBOutlet weak var textBackground: UIView!
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var movieSynopsisLabel: UILabel!
  @IBOutlet weak var criticsScoreLabel: UILabel!
  @IBOutlet weak var audienceScoreLabel: UILabel!

  var movie: Movie!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = movie.title
    
    foreground.delegate = self
    foreground.alwaysBounceVertical = true
    textBackground.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
    
    movieTitleLabel.text = movie.title
    movieSynopsisLabel.text = movie.synopsis
    criticsScoreLabel.text = movie.criticsScore
    audienceScoreLabel.text = movie.audienceScore
    posterView.setImageWithURL(movie.posterURL)
    
    // Calculate the height needed to display the full the synopsis text
    let maxRectSize = CGSize(width: movieSynopsisLabel.frame.size.width, height: CGFloat.max)
    let synopsisLabelRect = (movieSynopsisLabel.text! as NSString).boundingRectWithSize(maxRectSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: movieSynopsisLabel.font], context: nil)
    let synopsisHeight = ceil(synopsisLabelRect.size.height)
    // The height of the visible portion of the synposis label is the screen height minus the synopsis label's y origin
    let synopsisVisibleHeight = self.view.frame.height - (textBackground.frame.origin.y + movieSynopsisLabel.frame.origin.y)

    // Update the synopsis label's height to fit the synopsis text
    movieSynopsisLabel.frame = CGRect(x: movieSynopsisLabel.frame.origin.x, y: movieSynopsisLabel.frame.origin.y, width: movieSynopsisLabel.frame.width, height: synopsisHeight)
    // Update the height of the translucent background behind the synopsis text
    // NOTE: we pad the height with an additional length of a full-screen so that the translucent background still appears
    // when the background gets pulled above its actual position
    textBackground.frame = CGRect(x: textBackground.frame.origin.x, y: textBackground.frame.origin.y, width: textBackground.frame.width, height: synopsisHeight + movieSynopsisLabel.frame.origin.y + self.view.frame.height)
    // Update the height of the scroll view to the height needed to display the synopsis plus 20px padding
    foreground.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + synopsisHeight - synopsisVisibleHeight + (tabBarController?.tabBar.frame.height)! + 20)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
