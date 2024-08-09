//
//  DatabaseManager.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/23/24.
//

import Foundation
import Supabase

struct Hours: Codable {
    let id: Int
    let createdAt: Date
    let day: Int
    let start: Int
    let end: Int
    
    enum CodingKeys: String, CodingKey {
        case id, day, start, end
        case createdAt = "created_at"
    }
}

struct Appointment: Codable {
    var id: Int?
    let createdAt: Date
    let name: String
    let email: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, date
        case createdAt = "created_at"
    }
}

let supabaseURL = URL(string: "https://vrltoshyvfagwqmucqpu.supabase.co")!
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZybHRvc2h5dmZhZ3dxbXVjcXB1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0NDU0NDMsImV4cCI6MjAzMjAyMTQ0M30.2lpDIe5ctPBMQUZ3SDr7LF99x-UzsPF5U-rqWwFJXiU"

let client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)

class DatabaseManager: ObservableObject {
    
    @Published var availableDates = [Date]()
    @Published var days: Set<String> = []
    
    init() {
        Task{
            do {
                let dates = try await self.fetchAvailableAppointments()
                await MainActor.run {
                    availableDates = dates
                    days = Set(availableDates.map({ $0.monthDayYearFormat() }))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchHours() async throws -> [Hours] {
        let response: [Hours] = try await client.from("hours").select().execute().value
        return response
    }
    
    private func fetchAvailableAppointments() async throws -> [Date] {
        let appts: [Appointment] = try await client.from("appointments").select().execute().value
        
        return try await generateAppointmentTimes(from: appts)
    }
    
    private func generateAppointmentTimes(from appts: [Appointment]) async throws -> [Date]{
        let takenAppts: Set<Date> = Set(appts.map({ $0.date }))
        let hours = try await fetchHours()
        
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: Date()) - 2
        
        var timeSlots = [Date]()

        for weekOffset in 0...7 {
            let dayOffset = weekOffset * 7
            
            for hour in hours {
                var currentDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()) + dayOffset + (hour.day - currentWeekday), hour: hour.start))!
                
                while let nextDate = calendar.date(byAdding: .minute, value: 30, to: currentDate), calendar.component(.hour, from: nextDate) <= hour.end {
                    if !takenAppts.contains(currentDate) && currentDate > Date() && calendar.component(.hour, from: currentDate) != hour.end{
                        timeSlots.append(currentDate)
                    }
                    currentDate = nextDate
                }
            }
        }
        
        return timeSlots
    }
    
    func bookAppointment(name: String, email: String, notes: String, date: Date) async throws {
        let appointment = Appointment(createdAt: Date(), name: name, email: email, date: date)
        let _ = try await client.from("appointments").insert(appointment).execute()

    }
    
        
}



