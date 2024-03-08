//
//  BirthEntryView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/01.
//

import SwiftUI

struct BirthEditView: View {
    let explanationText = ExplanationText()
    @Binding var birth: String
    @Binding var path: [MyPagePath]
    @State var isBirthValid: Bool = false
    @FocusState var keybordFocus: Bool
    
    let maxBirthLength: Int = 8
    var body: some View {
        ZStack {
            VStack {
                Text(explanationText.birthEntryDescription)
                    .font(.title3)
                    .padding()
                
                ZStack {
                    // 生年月日を表示
                    HStack {
                        // 年
                        ForEach(1..<5) { num in
                            if let birthNumber = birth.forthText(forthNumber: num) {
                                Text(birthNumber)
                                    .font(.largeTitle)
                            } else {
                                Text("0")
                                    .foregroundStyle(Color(UIColor.lightGray))
                                    .font(.largeTitle)
                            }
                        }
                        
                        Text("/")
                        
                        // 月
                        ForEach(5..<7) { num in
                            if let birthNumber = birth.forthText(forthNumber: num) {
                                Text(birthNumber)
                                    .font(.largeTitle)
                            } else {
                                Text("0")
                                    .foregroundStyle(Color(UIColor.lightGray))
                                    .font(.largeTitle)
                            }
                        }
                        
                        Text("/")
                        
                        // 日
                        ForEach(7..<9) { num in
                            if let birthNumber = birth.forthText(forthNumber: num) {
                                Text(birthNumber)
                                    .font(.largeTitle)
                            } else {
                                Text("0")
                                    .foregroundStyle(Color(UIColor.lightGray))
                                    .font(.largeTitle)
                            }
                        }
                    }
                    .onTapGesture {
                        self.keybordFocus.toggle()
                    }
                    
                    TextField("", text: $birth)
                        .focused(self.$keybordFocus)
                        .padding()
                        .font(.largeTitle)
                        .background(Color.cyan)
                        .opacity(0)
                        .onChange(of: birth) {
                            if birth.count > maxBirthLength {
                                birth = String(birth.prefix(maxBirthLength))
                            }
                            
                            if let _ = birth.toDate() {
                                isBirthValid = true
                            } else {
                                isBirthValid = false
                            }
                        }
                }
                
                if !isBirthValid {
                    Text(explanationText.birthEntryError)
                        .foregroundStyle(Color.red)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                
                Spacer()
            }
            .keyboardType(.decimalPad)
            
            VStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        
                    }
                }, label: {
                    Text("次へ")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(isBirthValid ? Color.pink.opacity(0.8) : Color(UIColor.lightGray))
                        .clipShape(Capsule())
                        .padding()
                })
                .disabled(!isBirthValid)
            }
        }
        .onAppear {
            if birth.count > maxBirthLength {
                birth = String(birth.prefix(maxBirthLength))
            }
            
            if let _ = birth.toDate() {
                isBirthValid = true
            } else {
                isBirthValid = false
            }
        }
    }
}

#Preview {
    struct PreviewView: View {
        @State var birth: String = ""
        @State var path: [MyPagePath] = []
        var body: some View {
            BirthEditView(
                birth: $birth,
                path: $path
            )
        }
    }
    
    return PreviewView()
}
