//
//  DetailViewController.swift
//  SoccerApp
//
//  Created by Developer RL on 29/08/21.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var stadionLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var webTV: UITextView!
    @IBOutlet weak var twitterTV: UITextView!
    @IBOutlet weak var fbTV: UITextView!
    @IBOutlet weak var igTV: UITextView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    var data: TeamModel?
    
    let baseVM = BaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        self.title = data?.strTeam
        
        self.topLabel.text = data?.strTeam
        self.imgLogo?.sd_setImage(with: URL(string: data?.strTeamBadge ?? ""), completed: nil)
        
        self.clubLabel.text = " \(data?.strAlternate ?? "")  "
        self.yearLabel.text = data?.intFormedYear
        self.stadionLabel.text = data?.strStadium
        self.descTV.text = data?.strDescriptionEN
        self.webTV.text = data?.strWebsite
        self.twitterTV.text = data?.strTwitter
        self.fbTV.text = data?.strFacebook
        self.igTV.text = data?.strInstagram
        
        setupBarButton()
    }
    
    func setupBarButton(){
        let isFav = baseVM.getFavTeams().contains(where: {
            $0.idTeam == self.data?.idTeam
        })
        
        if isFav{
            favButton?.image = UIImage(named: "star.fill")
        } else {
            favButton?.image = UIImage(named: "star")
        }

    }
    
    @IBAction func favClicked(_ sender: Any) {
        if let _data = self.data{
            baseVM.addFavTeams(data: _data)
            setupBarButton()
        }
    }
}
