//
//  MeokuApp.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//

import SwiftUI

@main
struct MeokuApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MeokuDayMenuView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack(spacing: 4) {
                                Image("meokuPNG")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 19)

                                Image("MeokuLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 14)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // 햄버거 메뉴 액션
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .toolbarBackground(Color.gray.opacity(0.05), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

