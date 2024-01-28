//
//  MapType.swift
//  BucketList
//
//  Created by Oleg Gavashi on 28.01.2024.
//

import Foundation


struct MapType: Identifiable {
    let label: String
    let key: String
    var id: String { key }
}
