//
//  ContentView.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var manager = DatabaseManager()
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thurs", "Fri", "Sat"]
    @State private var selectedMonth = 0
    @State private var selectedDate = Date()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Image("picture")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .cornerRadius(64)
                
                Text("JP Foot Spa")
                    .font(.title)
                    .bold()
                
                Divider()
                    .foregroundColor(.gray)
                
                VStack(spacing: 16) {
                    Text("Select a Day")
                        .font(.title2)
                        .bold()
                    //Month selection below
                    HStack{
                        Spacer()
                        
                        Button {
                            withAnimation {
                                selectedMonth -= 1
                            }
                        } label:{
                            Image(systemName: "lessthan.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:30, height:30)
                                .foregroundColor(.gray)
                        }
                        
                        
                        Spacer()
                        
                        Text(selectedDate.monthAndYear())
                            .font(.title2)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                selectedMonth += 1
                            }
                        } label: {
                            Image(systemName: "greaterthan.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:30, height:30)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        ForEach(days, id:\.self) { day in
                            Spacer()
                            Text(day)
                                .font(.system(size: 12, weight: .medium))
                            Spacer()
                        }
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20){
                        ForEach(fetchDates()) { value in
                            if value.day != -1 {
                                let hasAppts = manager.days.contains(value.date.monthDayYearFormat())
                                
                                NavigationLink(value: AppRouter.dayTo(date: value.date)) {
                                    Text("\(value.day)")
                                        .foregroundColor(hasAppts ? .blue : .black)
                                        .fontWeight(hasAppts ? .bold : .none)
                                        .background {
                                            ZStack(alignment: .bottom) {
                                                Circle()
                                                    .frame(width:48, height: 48)
                                                    .foregroundColor(hasAppts ? .blue.opacity(0.1) : .clear)
                                                
                                                if value.date.monthDayYearFormat() == Date().monthDayYearFormat() {
                                                    Circle()
                                                        .frame(width: 8, height: 8)
                                                        .foregroundColor(hasAppts ? .blue : .gray)
                                                }
                                            }
                                        }
                                }
                                .disabled(!hasAppts)
                            }
                            else {
                                Text("")
                            }
                        }
                        
                        .frame(width: 30, height : 30)
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .onChange(of: selectedMonth) {
                selectedDate = fetchSelectedMonth()
            }
            
            .navigationDestination(for: AppRouter.self) {router in
                switch router{
                case.dayTo(let date):
                    DayView(path: $path, currentDate: date)
                        .environmentObject(manager)
                case.booking(let date):
                    BookingView(path: $path, currentDate: date)
                        .environmentObject(manager)
                case.confirmation(let date):
                    ConfirmationView(path: $path, currentDate: date)
                }
            }
        }
    }
    
        
        func fetchDates() -> [CalendarDate] {
            let calendar = Calendar.current
            let currentMonth = fetchSelectedMonth()
            
            var dates = currentMonth.datesOfMonth().map({ CalendarDate(day: calendar.component(.day, from: $0), date: $0) })
            
            let firstDayOfWeek = calendar.component(.weekday, from: dates.first?.date ?? Date())
            
            for _ in 0..<firstDayOfWeek - 1 {
                dates.insert(CalendarDate(day: -1, date: Date()), at:0)
            }
            
            return dates
        }
        
        func fetchSelectedMonth() -> Date {
            let calendar = Calendar.current
            
            let month = calendar.date(byAdding: .month, value: selectedMonth, to: Date())
            
            return month!
        }
    }
    struct CalendarDate: Identifiable {
        let id = UUID()
        var day: Int
        var date: Date
    }

#Preview {
    HomeView()
}
