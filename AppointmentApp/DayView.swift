//
//  DayView.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/20/24.
//

import SwiftUI

struct DayView: View {
    @EnvironmentObject var manager: DatabaseManager
    @State var dates = [Date]()
    
    @State var selectedDate: Date?
    
    @Binding var path: NavigationPath
    
    var currentDate: Date
    
    var body: some View{
        ScrollView {
            VStack {
                Text(currentDate.fullMonthDayYearFormat())
                
                Divider()
                    .padding(.vertical)
                
                Text("Select a Time")
                    .font(.largeTitle)
                    .bold()
                
                Text("Duration: 30/60/90 min")
                
                ForEach(dates, id: \.self) { date in
                    HStack {
                        Button {
                            withAnimation {
                                selectedDate = date
                            }
                        } label: {
                            Text(date.timeFromDate())
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedDate == date ? .white : .blue)
                                .background(
                                    ZStack {
                                        if selectedDate == date {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.gray)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke()
                                        }
                                    }
                                )
                        }
                        
                        if selectedDate == date {
                            NavigationLink(value: AppRouter.booking(date:date)) {
                                Text("Next")
                                    .bold()
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.blue)
                                    )
                            }
                        }
                    }

                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            self.dates = manager.availableDates.filter({ $0.monthDayYearFormat() == currentDate.monthDayYearFormat() })
        }
        .navigationTitle(currentDate.dayOfTheWeek())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            DayView(path: .constant(NavigationPath()), currentDate: Date())
        }
    }
}
