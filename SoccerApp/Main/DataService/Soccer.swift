//
//  Soccer.swift
//  SoccerApp
//
//  Created by Developer RL on 18/08/21.
//

import Foundation
import Moya

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

let soccerProvider = MoyaProvider<Soccer>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),logOptions: .verbose))])

public enum Soccer {
    case allLeagues
    case allTeamByLeagueId(id: Int)
    case searchTeamByName(name: String)
    
}

extension Soccer: TargetType {
    
    public var baseURL: URL { return URL(string: "https://www.thesportsdb.com/api/v1/json/1")!
    }
    
    public var path: String {
        switch self{
        case .allLeagues:
            return "/all_leagues.php"
        case .allTeamByLeagueId:
            return "/lookup_all_teams.php"
        case .searchTeamByName:
            return "/searchteams.php"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .allLeagues:
            return .requestPlain
        case .allTeamByLeagueId(id: let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .searchTeamByName(name: let name):
            return .requestParameters(parameters: ["t": name], encoding: URLEncoding.queryString)
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
           return ["Content-type": "application/json"]
       }
    
}
