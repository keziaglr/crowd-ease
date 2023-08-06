//
//  StationsList.swift
//  CrowdCountUIMacOS
//
//  Created by Azella Mutyara on 20/07/23.
//

import Foundation

// Separate the station name and sponsor using a tuple
typealias StationSponsor = (station: String, sponsor: String?)

// Create the station list with station names and sponsors (if applicable)
let stationList: [StationSponsor] = [
    ("Lebak Bulus", "Grab"),
    ("Fatmawati", "Indomaret"),
    ("Cipete Raya", nil),
    ("Haji Nawi", nil),
    ("Blok A", nil),
    ("Blok M", "BCA"),
    ("ASEAN", nil),
    ("Senayan", nil),
    ("Istora", "Mandiri"),
    ("Bendungan Hilir", nil),
    ("Setiabudi", "Astra"),
    ("Dukuh Atas", "BNI"),
    ("Bundaran HI", nil)
]

let offsetY = [-25, 25, -17, 17, -17, 25, -17, 17, -25, 17, -25, 25, -17]
