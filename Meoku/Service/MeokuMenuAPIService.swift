//
//  MeokuMenuAPIService.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/12/25.
//
import Foundation

// ObservableObject를 채택하여 뷰에서 이 객체를 구독하고 반응하도록 함
class MenuAPIService: ObservableObject {
    
    // @Published는 값이 바뀌면 SwiftUI 뷰에 자동 반영되게 해줌
    @Published var weekMenus: [MenuDaily] = []

    // 특정 날짜의 식단 데이터를 서버에서 가져오는 함수
    func fetchMenus(for date: Date) {
        // Date를 "yyyy-MM-dd" 형태의 문자열로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date.getMondayOfWeek) // 받은 날짜기준 해당주의 월요일로 조회

        // API 요청할 URL 생성
        guard let url = URL(string: "https://port-0-meokuserver-1cupyg2klv9emciy.sel5.cloudtype.app/api/v1/meokumenu/weekdaysmenu") else { return }

        // URLRequest 생성하고 POST 메서드 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // 요청 헤더에 Content-Type을 JSON으로 명시
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 요청 바디에 보낼 JSON 데이터 (딕셔너리 형태)
        let body = ["date": dateString]
        // JSON으로 변환하여 요청에 담음
        request.httpBody = try? JSONEncoder().encode(body)

        // 네트워크 요청 시작 (비동기 처리)
        URLSession.shared.dataTask(with: request) { data, _, error in
            // 에러나 데이터가 없을 경우 처리
            guard let data = data else {
                print("API error:", error ?? "Unknown") // 에러 로그 출력
                return
            }

            do {
                // 응답 받은 JSON 데이터를 [MenuDaily] 타입으로 디코딩
                let result = try JSONDecoder().decode([MenuDaily].self, from: data)
                
                // UI 갱신은 메인 스레드에서 실행해야 하므로 DispatchQueue 사용
                DispatchQueue.main.async {
                    self.weekMenus = result
                }
//                DispatchQueue.main.async {
//                    if let first = result.first {
//                        // 날짜별로 데이터를 저장
//                        self.menusByDate[dateString] = first.menuDetailsList
//                    }
//                }
            } catch {
                // 디코딩 실패시 에러 로그
                print("Decoding error:", error)
            }
        }.resume() // 네트워크 요청 실행
    }
}
