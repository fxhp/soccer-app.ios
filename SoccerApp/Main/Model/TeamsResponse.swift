//
//  TeamModel.swift
//  SoccerApp
//
//  Created by Developer RL on 22/08/21.
//

import Foundation

struct TeamsResponse: Codable {
    let teams: [TeamModel]
}

struct TeamModel: Codable, Equatable, Comparable{
    static func < (lhs: TeamModel, rhs: TeamModel) -> Bool {
        return lhs.strTeam! < rhs.strTeam!
    }
    
    let idTeam: String?
    let strTeam: String?
    let strLeague: String?
    let strTeamShort: String?
    let strAlternate: String?
    let intFormedYear: String?
    let strStadium: String?
    let strTeamBadge: String?
    let strDescriptionEN: String?
    let strWebsite: String?
    let strFacebook: String?
    let strTwitter: String?
    let strInstagram: String?
}
