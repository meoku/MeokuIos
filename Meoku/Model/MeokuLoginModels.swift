//
//  MeokuLoginModels.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/16/25.
//
import Foundation

struct LoginRequest: Codable {
    let id: String
    let password: String
}

struct LoginResponse: Codable {
    let nickname: String
    let access_token: String
    let refresh_token: String
}
