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
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    MeokuDayMenuView()
                    
                    // 어두운 배경 영역
                    Color.black
                        .opacity(showSidebar ? 0.3 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showSidebar = false
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: showSidebar)

                    // 사이드바
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 20) {
                            // 로그인 버튼 (상단)
                            HStack(spacing: 0) {
                                NavigationLink(destination: LoginView()) {
                                    Text("로그인")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.primary)
                                        .baselineOffset(-1)
                                }
                            }
                            .padding(.top, 20)

                            // 첫 번째 구분선
                            Rectangle()
                                .fill(Color.primary.opacity(0.1))
                                .frame(height: 1)

                            // 메뉴들 (왼쪽 정렬)
                            Button("구내식당표") {
                                // TODO
                            }
                            .font(.system(size: 17))
                            .foregroundColor(.primary)

                            Button("맛집지도") {
                                alertMessage = "준비중인 서비스입니다."
                                showAlert = true
                            }
                            .font(.system(size: 17))
                            .foregroundColor(.primary)

                            Button("AI추천") {
                                alertMessage = "준비중인 서비스입니다."
                                showAlert = true
                            }
                            .font(.system(size: 17))
                            .foregroundColor(.primary)

                            // 두 번째 구분선
                            Rectangle()
                                .fill(Color.primary.opacity(0.1))
                                .frame(height: 1)

                            Spacer()

                        }
                        .frame(width: 200)
                        .padding(.top, 20)
                        .padding(.horizontal)
                        .background(Color(.systemBackground))
                        .shadow(radius: 5)

                        Spacer()
                    }
                    .offset(x: showSidebar ? 0 : -250)
                    .animation(.easeInOut(duration: 0.3), value: showSidebar)
                }
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("확인", role: .cancel) {}
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
