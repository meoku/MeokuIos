//
//  Data+extention.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//
import Foundation

extension Date {
    /// 오늘 날짜 반환
    static var getToday: Date {
        return Date()
    }

    /// 내 날짜가 오늘인지 여부 (년,월,일 기준 비교)
    var isTodayYn: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }

    /// 내 날짜로 해당 주의 월~금 Date 배열 반환
    var getWeekDateList: [Date] {
        let calendar = Calendar(identifier: .gregorian)
        let monday = self.getMondayOfWeek
        return (0..<5).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }
    
    /// 월~금 요일 인덱스 (월:0, ..., 금:4, 토/일:0)
    var getWeekdayIndex: Int {
        let calendar = Calendar(identifier: .gregorian)
        let weekday = calendar.component(.weekday, from: self)
        switch weekday {
        case 2...6: return weekday - 2 // Monday = 2 -> 0, Friday = 6 -> 4
        default: return 0 // Saturday(7), Sunday(1)
        }
    }
    
    /// "M월 N주차" 반환
    var getMonthAndWeekString: String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // 월요일 시작

        let month = calendar.component(.month, from: self)
        let week = calendar.component(.weekOfMonth, from: self)
        return "\(month)월 \(week)주차"
    }
    
    /// 내가 속한 주간의 월요일 날짜 반환 (월~일 기준)
    var getMondayOfWeek: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // 월요일 시작
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: self)?.start
        return startOfWeek ?? self
    }
    
    /// 내 날짜의 요일 문자열 반환 (예: "월", "화", ...)
    var getDayOfTheWeek: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    // 내 날짜의 일 반환 (예: 1, 2, ..., 31)
    var getDay: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    /// 주차 단위로 날짜 이동
    func adjustedByWeek(offset: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .weekOfMonth, value: offset, to: self) ?? self
    }
    
}
