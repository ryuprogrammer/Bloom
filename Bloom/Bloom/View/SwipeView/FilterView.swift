//
//  FilterView.swift
//  Bloom
//
//  Created by トム・クルーズ on 2024/03/23.
//

import SwiftUI

struct FilterView: View {
    // MARK: - 検索条件
    /// vipか
    @State var isVip: Bool = true
    /// 居住地
    @State var address: [String] = []
    /// 年齢
    @State var age: String? = nil
    /// 最小年齢
    @State var minAge: Int = 18
    /// 最長年齢
    @State var maxAge: Int = 30
    /// 距離
    @State var distance: Double = 30
    /// 趣味
    @State var hobby: String? = nil

    // MARK: - シートのトグル
    @State var isShowAddressView: Bool = false

    // MARK: - ボタンが有効か
    @State var isValidButton: Bool = false
    @State var isShowAgePicker: Bool = false

    let pickerHeight = UIScreen.main.bounds.height / 4
    let pickerOffset = UIScreen.main.bounds.height

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        ListRowView(
                            viewType: .FilterView,
                            image: "mappin.and.ellipse",
                            title: "居住地",
                            detail: address.isEmpty ? nil : address.joined(separator: "・")
                        )
                        .onTapGesture {
                            isShowAddressView = true
                        }

                        ListRowView(
                            viewType: .FilterView,
                            image: "birthday.cake",
                            title: "年齢",
                            detail: String(minAge) + "〜" + String(maxAge)
                        )
                        .onTapGesture {
                            withAnimation(.linear) {
                                isShowAgePicker.toggle()
                            }
                        }
                    } header: {
                        Text("無料フィルター")
                    }

                    Section {
                        VStack {
                            ListRowView(
                                viewType: .FilterView,
                                isVip: true,
                                image: "arrow.left.and.right",
                                title: "距離",
                                detail: isVip ? (String(floor(distance)) + "km") : nil
                            )

                            Slider(
                                value: $distance,
                                in: 5...100,
                                step: 1.0
                            )
                            .tint(.pink.opacity(0.8))
                        }

                        ListRowView(
                            viewType: .FilterView,
                            isVip: true,
                            image: "birthday.cake",
                            title: "趣味",
                            detail: hobby
                        )

                        ListRowView(
                            viewType: .FilterView,
                            isVip: true,
                            image: "wallet.pass",
                            title: "職業",
                            detail: hobby
                        )

                        ListRowView(
                            viewType: .FilterView,
                            isVip: true,
                            image: "wallet.pass",
                            title: "グレード",
                            detail: hobby
                        )
                    } header: {
                        Text("VIPプラン限定フィルター")
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.vipStart, Color.vipEnd]), startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }

                VStack {
                    Spacer()

                    ButtonView(
                        title: "条件を保存",
                        imageName: "magnifyingglass",
                        isValid: $isValidButton,
                        action: {
                            
                        }
                    )

                    // 年齢選択のPicker
                    AgePickerView(minAge: $minAge, maxAge: $maxAge, isShowing: $isShowAgePicker)
                        .frame(height: self.isShowAgePicker ? pickerHeight : 0)
                        .offset(y: self.isShowAgePicker ? 0 : pickerOffset)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("フィルター", displayMode: .inline)
            // 画面遷移を制御
            .sheet(isPresented: $isShowAddressView, content: {
                AddressFilterView(address: $address)
            })
        }
    }
}

#Preview {
    FilterView()
}
