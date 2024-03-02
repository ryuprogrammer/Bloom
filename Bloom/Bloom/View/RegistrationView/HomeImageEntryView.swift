//
//  HomeImageEntryView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/02.
//

import SwiftUI
import PhotosUI

struct HomeImageEntryView: View {
    let explanationText = ExplanationText()
    @State var selectedItem: PhotosPickerItem?
    @Binding var homeImage: UIImage
    @Binding var registrationState: RegistrationState
    @State var isImageValid: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.pink.opacity(0.2))
                            .strokeBorder(Color.pink.opacity(0.8), lineWidth: 5)
                            .frame(width: 200, height: 200)
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundStyle(Color.white)
                    }
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("ホーム写真")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            registrationState = .address
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundStyle(Color.black)
                        })
                    }
                }
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        registrationState = .doneAll
                    }
                }, label: {
                    Text("次へ")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(isImageValid ? Color.pink.opacity(0.8) : Color(UIColor.lightGray))
                        .clipShape(Capsule())
                        .padding()
                })
                .disabled(!isImageValid)
            }
        }
    }
}

#Preview {
    struct PreviewView: View {
        @State var homeImage: UIImage = UIImage()
        @State var registrationState: RegistrationState = .noting
        var body: some View {
            HomeImageEntryView(homeImage: $homeImage, registrationState: $registrationState)
        }
    }
    
    return PreviewView()
}
