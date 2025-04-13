//
//  MeokuMealOrderModels.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/13/25.
//

import Foundation


struct MealOrder: Identifiable, Codable {
    var id: Int { mealOrderId }
    let mealOrderId: Int
    let mealOrder: Int
    let mealTime: String
    let mealTarget: String
}

struct MealOrderGroup: Codable {
//    let mealOrderStateDate : Date
//    let mealOrderEndDate : Date
    let responseBody: [MealOrder]
}
