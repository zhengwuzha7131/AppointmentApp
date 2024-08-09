//
//  Router.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/27/24.
//

import Foundation

enum AppRouter: Hashable {
    case dayTo(date: Date)
    case booking(date: Date)
    case confirmation(date: Date)
}
