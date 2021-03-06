//
//  TweetCell.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import AFNetworking
import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!

    var controller: UIViewController?
    var clickableNames = true

    var tweet: Tweet? {
        didSet {
            tweetLabel.text = tweet?.text
            screennameLabel.text = "@" + (tweet?.user?.screenname)!
            nameLabel.text = tweet?.user?.name
            let avatarImageRequest = NSURLRequest(URL: (tweet?.user?.profileImageURL)!)
            avatarImageView.setImageWithURLRequest(avatarImageRequest, placeholderImage: nil,
                success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                    self.avatarImageView.image = image
                }, failure: { (request, response,error) -> Void in
                    print("Something went wrong with the image load")
                }
            )
            ageLabel.text = tweet?.age()
            setFavoritedImage()
            setRetweetedImage()

            if clickableNames {
                nameLabel.userInteractionEnabled = true
                let tgr = UITapGestureRecognizer(target: self, action: "onNameTap:")
                nameLabel.addGestureRecognizer(tgr)
            }
        }
    }

    func onNameTap(sender: UILabel){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let profileViewController = storyBoard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.user = tweet?.user
        controller!.navigationController?.pushViewController(profileViewController, animated: true)
    }

    func setFavoritedImage() {
        if (tweet?.isFavorited)! {
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
        }
    }

    func setRetweetedImage() {
        if (tweet?.isRetweeted)! {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action-inactive.png"), forState: .Normal)
        }
    }

    @IBAction func replyToTweet(sender: AnyObject) {
        if controller != nil {
            controller?.performSegueWithIdentifier("toCreateTweetDetailSegue", sender: self)
        }
    }

    @IBAction func retweetTweet(sender: AnyObject) {
        tweet!.invertRetweet() { () -> Void in
            self.setRetweetedImage()
        }
    }

    @IBAction func favoriteTweet(sender: AnyObject) {
        tweet!.invertFavorite() { () -> Void in
            self.setFavoritedImage()
        }
    }
}