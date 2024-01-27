//
//  fetchNearby.swift
//  BucketList
//
//  Created by Oleg Gavashi on 27.01.2024.
//

import Foundation

func fetchNearby(_ location: Location) async throws -> [Page]? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "en.wikipedia.org"
    components.path = "/w/api.php"
    components.queryItems = [
        URLQueryItem(name: "ggscoord", value: "\(location.latitude)|\(location.longtitude)"),
        URLQueryItem(name: "action", value: "query"),
        URLQueryItem(name: "prop", value: "coordinates|pageimages|pageterms"),
        URLQueryItem(name: "colimit", value: "50"),
        URLQueryItem(name: "piprop", value: "thumbnail"),
        URLQueryItem(name: "pithumbsize", value: "500"),
        URLQueryItem(name: "pilimit", value: "50"),
        URLQueryItem(name: "wbptterms", value: "description"),
        URLQueryItem(name: "generator", value: "geosearch"),
        URLQueryItem(name: "ggsradius", value: "10000"),
        URLQueryItem(name: "ggslimit", value: "50"),
        URLQueryItem(name: "format", value: "json")
    ]
    
    guard let url = components.url else {
        print("Bad URL")
        
        return nil
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let items = try JSONDecoder().decode(Result.self, from: data)
        
        let pages = items.query.pages.values.sorted()
        
        return pages
    } catch {
        throw error
    }
}
