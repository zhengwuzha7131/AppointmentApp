//
//  ConfirmationView.swift
//  AppointmentApp
//
//  Created by William Zhang on 5/23/24.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var path: NavigationPath

    var currentDate: Date
        
    var body: some View {
        VStack {
            Image("picture")
                .resizable()
                .scaledToFill()
                .frame(width:128, height: 128)
                .cornerRadius(64)
            
            Text("Confirmed")
                .font(.title2)
                .bold()
                .padding()
            
            Text("You are schedule with ___")
            
            Divider()
                .padding()
            
            VStack(alignment: .leading, spacing: 32){
                HStack {
                    Circle()
                        .frame(width:20, height: 20)
                        .foregroundColor(.orange)
                    
                    Text("Caleny Course")
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
            
            Spacer()
            
            Button {
                path = NavigationPath()
            } label: {
                Text("Done")
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
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct ConfirmationView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ConfirmationView(path: .constant(NavigationPath()), currentDate: Date())
        }
    }
}
