//
//  MainViewController.swift
//  SoccerApp
//
//  Created by Developer RL on 22/08/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueView: UICollectionView!
    @IBOutlet weak var leagueViewTop: NSLayoutConstraint!
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    var dataTeams: [TeamModel] = []
    var dataLeague: [LeagueModel] = []
    let baseVM = BaseViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var isOnSearch: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
    var modeFav = false
    var shouldHideLeagueView = false{
        didSet{
            self.hideLeagueView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = leagueView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Teams"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isOnSearch{
            callGetAllLeague()
            callGetAllTeamsByLeague()
        }
    }
    
    //MARK: - API
    private func callGetAllLeague(){
        self.showLoading()
        soccerProvider.request(.allLeagues) { result in
            switch result {
            case let .success(moyaResponse):
                do{
                    self.dataLeague = (try moyaResponse.map(LeagueResponse.self).leagues).filter{
                        $0.strSport == "Soccer"
                    }
                    self.hideLoading()
                    self.leagueView.reloadData()
                }catch{
                    self.hideLoading()
                    self.showPopupWith(title: "Warning", content: "Data Not Found", button: "Ok")
                }
            case let .failure(error):
                self.hideLoading()
                self.showPopupWith(title: "Error get data", content: error.localizedDescription, button: "Ok")
            }
        }
    }
    
    private func callGetAllTeamsByLeague(){
        self.showLoading()
        let leagueId = baseVM.getSelectedLeague()
        soccerProvider.request(.allTeamByLeagueId(id: Int(leagueId)!)) { result in
            switch result {
            case let .success(moyaResponse):
                do{
                    self.dataTeams = (try moyaResponse.map(TeamsResponse.self).teams)
                    self.hideLoading()
                    self.tableView.reloadData()
                }catch{
                    self.hideLoading()
                    self.showPopupWith(title: "Warning", content: "Data Not Found", button: "Ok")
                }
            case let .failure(error):
                self.hideLoading()
                self.showPopupWith(title: "Error get data", content: error.localizedDescription, button: "Ok")
            }
        }
    }
    
    private func callSearchTeamsByName(name: String){
        self.showLoading()
        soccerProvider.request(.searchTeamByName(name: name)) { result in
            switch result {
            case let .success(moyaResponse):
                do{
                    self.dataTeams = (try moyaResponse.map(TeamsResponse.self).teams)
                    self.hideLoading()
                    self.tableView.reloadData()
                }catch{
                    self.hideLoading()
                    self.showPopupWith(title: "Warning", content: "Data Not Found", button: "Ok")
                }
            case let .failure(error):
                self.hideLoading()
                self.showPopupWith(title: "Error get data", content: error.localizedDescription, button: "Ok")
            }
        }
    }
    
    //MARK: - ACTION
    @objc private func favClicked(_ sender: UIButton) {
        let buttonPos = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPos)
        let data = dataTeams[indexPath!.row]
        baseVM.addFavTeams(data: data)
        if !isOnSearch{
            updateDataTeam()
        }
        tableView.reloadData()
    }
    
    @IBAction func barFavClicked(_ sender: Any) {
        modeFav = !modeFav
        self.title = modeFav ? "Your Favorite Team" : "Soccer App"
        shouldHideLeagueView = modeFav
        updateDataTeam()
        tableView.reloadData()
    }
    
    //MARK: - FUNCTION
    private func hideLeagueView(){
        leagueViewTop.constant = shouldHideLeagueView ? -leagueView.frame.size.height : 0
    }
    
    private func updateDataTeam(){
        if modeFav{
            self.favButton.image = UIImage(named: "star.circle.fill")
            self.dataTeams = baseVM.getFavTeams()
        }else{
            self.favButton.image = UIImage(named: "star.circle")
            callGetAllTeamsByLeague()
        }
    }
    
}

//MARK: - DELEGATE
extension MainViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataTeams.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.data = dataTeams[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
        
        let imgView = cell?.viewWithTag(100) as? UIImageView
        let teamName = cell?.viewWithTag(101) as? UILabel
        let leagueName = cell?.viewWithTag(102) as? UILabel
        let button = cell?.viewWithTag(103) as? UIButton
        
        let data = dataTeams[indexPath.row]
        teamName?.text = data.strTeam
        leagueName?.text = data.strLeague
        imgView?.sd_setImage(with: URL(string: data.strTeamBadge ?? ""), completed: nil)
        
        let isFav = baseVM.getFavTeams().contains(where: {
            $0.idTeam == data.idTeam
        })
        
        if isFav{
            button?.setImage(UIImage(named: "star.fill"), for: .normal)
        } else {
            button?.setImage(UIImage(named: "star"), for: .normal)
        }
        
        button?.addTarget(self, action: #selector(favClicked(_:)), for: .touchUpInside)
        return cell!
        
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataLeague.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leagueCell", for: indexPath)
        
        let leagueLabel = cell?.viewWithTag(100) as? UILabel
        leagueLabel?.text = self.dataLeague[indexPath.row].strLeague
        cell?.layoutIfNeeded()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        baseVM.saveSelectedLeague(data: self.dataLeague[indexPath.row].idLeague!)
        callGetAllTeamsByLeague()
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if !(searchBar.text?.isEmpty ?? true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.callSearchTeamsByName(name: searchBar.text!)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.shouldHideLeagueView = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.shouldHideLeagueView = false
        callGetAllTeamsByLeague()
    }
}
