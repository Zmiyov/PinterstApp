//
//  ImageModel.swift
//  PinterstApp
//
//  Created by Vladimir Pisarenko on 02.05.2024.
//

import Foundation

struct ImageModel: Identifiable, Codable {
    var id: String
    var download_url: String
    var onHover: Bool?
}
