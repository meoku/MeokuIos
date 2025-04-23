//
//  MeokuDayMenuView.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//
import SwiftUI

struct MeokuDayMenuView: View {
    @StateObject var menuService = MenuAPIService()
    @StateObject var menuOrderService = MeokuMenuOrderAPIService()
    @State var selectedDate = Date()
    @State var selectedIndex : Int = Date().getWeekdayIndex
    
    var weekDateList:[Date]{
        selectedDate.getWeekDateList
    }
    
    var body: some View {
        VStack {
            WeekHeaderView(selectedDate: $selectedDate, selectedIndex: $selectedIndex, menuService: menuService, menuOrderService:  menuOrderService)
                .padding()
            DayBoxView(selectedDate: $selectedDate, selectedIndex: $selectedIndex, weekDateList: weekDateList)
            MenuTabView(selectedIndex: $selectedIndex, weekDateList: weekDateList, menuService: menuService)
        }
        //.padding()
        .onAppear {
            menuService.fetchMenus(for: selectedDate)
        }
        .background(Color.lightGrayBackground)
    }
}

struct WeekHeaderView: View {
    @Binding var selectedDate : Date
    @Binding var selectedIndex : Int
    var menuService: MenuAPIService
    @ObservedObject var menuOrderService: MeokuMenuOrderAPIService
    
    @State private var showPopup = false
    @State private var mealOrders: [MealOrder] = []
    
    var body: some View {
        ZStack {
            
            HStack  {
                Button(action: {
                    selectedDate = selectedDate.adjustedByWeek(offset: -1)
                    selectedIndex = 4
                    menuService.weekMenus = []
                    menuService.fetchMenus(for: selectedDate)
                    
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                
                Text(selectedDate.getMonthAndWeekString)
                    .font(.title3)
                    .foregroundColor(Color(.sRGB, red: 1.0, green: 0.251, blue: 0.016, opacity: 1.0))
                    .bold()
                    .onTapGesture {
                        // 오늘 날짜 기준으로 주차로 변경
                        selectedDate = Date()
                        selectedIndex = selectedDate.getWeekdayIndex
                        menuService.fetchMenus(for: selectedDate)
                    }
                
                Button(action: {
                    selectedDate = selectedDate.adjustedByWeek(offset: 1)
                    selectedIndex = 0
                    menuService.weekMenus = []
                    menuService.fetchMenus(for: selectedDate)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                }
            }
            HStack{
                Spacer()
                Button("식사순서") {
                    menuOrderService.fetchMealOrder(for: selectedDate) //오늘날짜 인자로
                    showPopup = true
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                .cornerRadius(6)
            }
            
        }
        .sheet(isPresented: $showPopup) {
            VStack {
                Text("[\(selectedDate.getMonthAndWeekString)] 식사 순서")
                    .font(.headline)
                
                ForEach(menuOrderService.mealOrders) { order in
                    HStack {
                        Text(order.mealTarget)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .bold()
                        Text(order.mealTime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                    }
                    .padding(.vertical, 4)
                }

                    .multilineTextAlignment(.leading)
                Button("닫기") {
                    showPopup = false
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

struct DayBoxView: View {
    @Binding var selectedDate: Date
    @Binding var selectedIndex: Int
    var weekDateList : [Date]
    
    let weekdays = ["월", "화", "수", "목", "금"]
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Text(weekdays[index])
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(index == selectedIndex && weekDateList[index].isTodayYn ? Color(.sRGB, red: 1.0, green: 0.251, blue: 0.016, opacity: 1.0)
                                : (index == selectedIndex ? Color.gray : Color.gray.opacity(0.2)))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
            }
        }
    }
}

struct MenuTabView: View {
    @Binding var selectedIndex : Int
    var weekDateList : [Date]
    @ObservedObject var menuService: MenuAPIService
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<5) { index in
                Group {
                    if menuService.weekMenus.count == 5{ //일단 API로 식단을 가져온 경우
                        // 식단이
                        if menuService.weekMenus[index].restaurantOpenFg == "Y"
                        {
                            MenuDetailCardView(curDate :weekDateList[selectedIndex], menuDetails: menuService.weekMenus[index].menuDetailsList)
                        } else if menuService.weekMenus[index].holidayFg == "Y" && // 공휴일
                                    menuService.weekMenus[index].restaurantOpenFg == "N"
                        {
                            Text("공휴일")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        } else {
                            
                        }
                    }else{
                        Text("준비중입니다")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: selectedIndex) {oldValue, newValue in
            selectedIndex = newValue
        }
    }
}

struct MenuDetailCardView: View {
    var curDate : Date
    var menuDetails : [MenuDetail]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // 점심 Header
                HStack {
                    Text("\(curDate.getDayOfTheWeek)(\(curDate.getDay))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .bold()
                    Spacer()
                    Text("점심")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .bold()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(curDate.isTodayYn ? Color(.sRGB, red: 1.0, green: 0.251, blue: 0.016, opacity: 1.0) : Color.gray.opacity(0.2))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)

                    
                ForEach(menuDetails) { detail in
                    //석식 위에는 Header 따로 붙이기
                    if detail.menuDetailsName == "석식" {
                        // 석식 Header 추가
                        HStack {
                            Text("\(curDate.getDayOfTheWeek)(\(curDate.getDay))")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .bold()
                            Spacer()
                            Text("저녁")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .bold()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(curDate.isTodayYn ? Color(.sRGB, red: 1.0, green: 0.251, blue: 0.016, opacity: 1.0) : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                    }
                    //식단 내용
                    VStack(spacing: 0) {
                        VStack(alignment: .center, spacing: 4) {
                            // 식단 이름 + 돋보기
                            ZStack(alignment: .topTrailing) {
                                Text(detail.menuDetailsName)
                                    .font(.system(size: 20, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color.meokuWordColor)

                                Button(action: {
                                    // 검색 액션
                                }) {
                                    Image(systemName: "plus.magnifyingglass")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color.meokuWordColor)
                                }
//                                .padding(.top, 4)
                                .padding(.trailing, 20)
                            }
                            .padding(.bottom, 8)
                            
                            // 메뉴 채우기
                            ForEach(detail.subBridgeList.indices, id: \.self) { index in
                                Text(detail.subBridgeList[index].menuItemName)
                                    .font(.callout)
                                    .bold(index == 0)
                                    .foregroundColor(Color.meokuWordColor)
                            }
                        }
                        .padding(.leading, 12)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .background(Color.white)
//                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                    .cornerRadius(8)
                    
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
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
