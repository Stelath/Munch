//
//  JoinCircleView.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
//
//import SwiftUI
//
//struct RoomView: View {
//    @StateObject private var viewModel = RoomViewModel()
//    
//    var body: some View {
//        Spacer()
//        
//        if(viewModel.selectedRoomAction == RoomAction.joinRoom.rawValue)
//        {
//            VStack {
//                Spacer().frame(height: 50)
//                TextField("CODE", text: $viewModel.roomCode)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .frame(minWidth: 100)
//                    .keyboardType(.numberPad)
//                    .padding()
//                Button(action: viewModel.joinRoom) {
//                    Text("Join Room")
//                        .padding()
//                        .fontWeight(.bold)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }.padding()
//            }
//        } else if (viewModel.selectedRoomAction == RoomAction.createRoom.rawValue) {
//            
//        }
//        
//        Spacer()
//        PickerPlus(
//            selection: $viewModel.selectedRoomAction,
//            segments: RoomAction.allCases.map { $0.rawValue }
//        )
//        .font(.system(size: 16, weight: .regular))
//        .selectedFont(.system(size: 18, weight: .bold))
//        .frame(height: 80)
//        .padding()
//    }
//}
//
//#Preview {
//    RoomView()
//}
