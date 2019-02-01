//
//  HelpModel.swift
//  Lend It
//
//  Created by Grecia Escárcega on 1/31/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import Foundation



struct Help: Decodable {
    let id: String
    let title: String
    let text: String
    
    init(id: String, title: String, text: String) {
        self.id = id
        self.title = title
        self.text = text
    }
}
