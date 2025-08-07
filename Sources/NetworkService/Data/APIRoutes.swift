//
//  APIRoutes.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 25.03.2025.
//

import Foundation

struct APIRoutes {
    let baseURL = URL(string: "http://158.160.168.26:80")
    let eventsRoute: String = "/api/events/"
    let speakersRoute: String = "/api/speakers/"
    let tagsRoute: String = "/api/tags/"
}
