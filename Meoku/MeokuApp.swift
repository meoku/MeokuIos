//
//  MeokuApp.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//

import SwiftUI

@main
struct MeokuApp: App {
    @State private var showSidebar = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    MeokuDayMenuView()

                    if showSidebar {
                        // 어두운 배경 영역: 탭하면 사이드바 닫힘
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showSidebar = false
                                }
                            }

                        // 사이드바
                        HStack(spacing: 0) {
                            VStack(alignment: .trailing, spacing: 20) {
                                // 상단 메뉴
                                Button("구내식당표") {
                                    // TODO
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(.primary)

                                Button("맛집지도") {
                                    // TODO
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(.primary)

                                Button("AI추천") {
                                    // TODO
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(.primary)

                                Spacer()

                                // 하단 로그인 링크
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: LoginView()) {
                                        Text("로그인")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 20)
                                            .padding(.trailing, 12)
                                    }
                                }
                            }
                            .frame(width: 250)
                            .padding(.top, 100)
                            .padding(.horizontal)
                            .background(Color.white)
                            .shadow(radius: 5)

                            Spacer()
                        }
                        .offset(x: showSidebar ? 0 : -250)
                        .animation(.easeInOut(duration: 0.3), value: showSidebar)
                    }
                }
                .toolbar {
                    // 네비게이션 바 좌측: 로고 / 우측: 햄버거 메뉴 버튼
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
                            withAnimation {
                                showSidebar.toggle()
                            }
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
