//
//  BookingView.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/20/24.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var manager: DatabaseManager
    @State private var name = ""
    @State private var email = ""
    @State private var notes = ""
    
    @Binding var path: NavigationPath
    var currentDate: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "clock")
                    
                    Text("30 min")
                }
                
                HStack {
                    Image(systemName: "person")
                    
                    Text("In Person")
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "calendar")
                    
                    Text(currentDate.bookingViewDate())
                }
                
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16){
                Text("Enter Details")
                    .font(.title)
                    .bold()
                
                Text("Name")
                
                TextField("", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius:10)
                            .stroke()
                    )
                
                Text("Email")
                
                TextField("", text: $email)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius:10)
                            .stroke()
                    )
                
                Text("Please share anything that will help prepare for our meeting.")
                
                TextField("", text: $notes, axis: .vertical)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius:10)
                            .stroke()
                    )
                
                Spacer()
                
                Button {
                    if !name.isEmpty && !email.isEmpty {
                        Task {
                            do {
                                try await manager.bookAppointment(name: name, email: email, notes: notes, date: currentDate)
                                name = ""
                                email = ""
                                notes = ""
                                path.append(AppRouter.confirmation(date: currentDate))
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } label: {
                    Text("Schedule Event")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius:10)
                                .foregroundColor(.blue)
                        )
                }

            }
            
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Calendy Course")
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            BookingView(path: .constant(NavigationPath()), currentDate: Date())
        }
    }
}

