//
//  MeokuMenuModels.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//
import Foundation

struct MenuDaily: Codable, Identifiable {
    let id = UUID()
    let dailyMenuId: Int
    let menuDate: String
    let holidayFg: String
    let restaurantOpenFg: String
    let menuDetailsList: [MenuDetail]
}

struct MenuDetail: Codable, Identifiable {
    let id = UUID()
    let menuDetailsId: Int
    let mainMealYn: String
    let menuDetailsName: String
    let subBridgeList: [Bridge]
}

struct Bridge: Codable, Identifiable {
    let id = UUID()
    let menuItemName: String
    let mainMenuYn: String
}
