//
//  HelpModel.swift
//  Lend It
//
//  Created by Grecia Escárcega on 1/31/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import Foundation

struct HelpModel: Decodable {
    let id: Int
    let title: String
    let text: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case text
    }
}
