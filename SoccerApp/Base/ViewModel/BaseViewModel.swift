//
//  ViewModel.swift
//  SoccerApp
//
//  Created by Developer RL on 22/08/21.
//

import Foundation

class BaseViewModel{
    
    let defaults = UserDefaults.standard
    
    func saveSelectedLeague(data : String){
        defaults.set(data, forKey: "SelectedLeague")
        defaults.synchronize()
    }
    
    func getSelectedLeague() -> String {
        if let leagueId = defaults.string(forKey: "SelectedLeague"){
            return leagueId
        }else{
            return "4328"
        }
        
    }
    
    func addFavTeams(data : TeamModel){
        do {
            var fav = self.getFavTeams()
            if let index = fav.firstIndex(of: data) {
                fav.remove(at: index)
            }else{
                fav.append(data)
            }
            
            let jsonData = try JSONEncoder().encode(fav)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            defaults.removeObject(forKey: "FavTeams")
            defaults.set(jsonString, forKey: "FavTeams")
            defaults.synchronize()
        }catch{
            print(error)
        }
    }
    
    func getFavTeams() -> [TeamModel] {
//        let array = defaults.object(forKey:"FavTeams") as? [TeamModel] ?? [TeamModel]()
//        return array
        do{
            if let jsonData = defaults.string(forKey: "FavTeams")?.data(using: .utf8) {
                let data = try JSONDecoder().decode([TeamModel].self, from: jsonData).sorted()
                return data
            }else{
                return [TeamModel]()
            }
        }catch{
            print(error)
            return [TeamModel]()
        }
    }
}
