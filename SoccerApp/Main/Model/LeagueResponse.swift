//
//  LeagueResponse.swift
//  SoccerApp
//
//  Created by Developer RL on 22/08/21.
//

import Foundation

struct LeagueResponse: Codable {
    let leagues: [LeagueModel]
}

struct LeagueModel: Codable {
    let idLeague: String?
    let strLeague: String?
    let strLeagueAlternate: String?
    let strSport: String?
}
