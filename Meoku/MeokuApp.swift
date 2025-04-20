//
//  MeokuApp.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//

import SwiftUI

@main
struct MeokuApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    @State private var showSidebar = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some Scene {
        WindowGroup {
            CommonLayoutView(
                showSidebar: $showSidebar,
                showAlert: $showAlert,
                alertMessage: $alertMessage
            ) {
                MeokuDayMenuView()
            }
            .environmentObject(authViewModel)//앱 전체에서 로그인관련 기능을 쓰고 확인하려면 모든 뷰에서 접근 가능하도록 주입
        }
    }
}
