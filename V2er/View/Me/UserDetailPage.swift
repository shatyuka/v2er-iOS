//
//  UserDetailPage.swift
//  UserDetailPage
//
//  Created by Seth on 2021/7/28.
//  Copyright © 2021 lessmore.io. All rights reserved.
//

import SwiftUI
import Kingfisher

struct UserDetailPage: StateView, InstanceIdentifiable {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.isPresented) private var isPresented
    @EnvironmentObject private var store: Store
    @StateObject var statusBarConfigurator = StatusBarConfigurator()
    @State private var scrollY: CGFloat = 0.0
    private let heightOfNodeImage = 60.0
    @State private var bannerViewHeight: CGFloat = 0
    @State private var currentTab: TabButton.ID = .topic
    @Namespace var animation
    // FIXME: couldn't be null
    var userId: String?
    var instanceId: String {
        userId ?? .default
    }

    var state: UserDetailState {
        if store.appState.userDetailStates[instanceId] == nil {
            store.appState.userDetailStates[instanceId] = UserDetailState()
        }
        return store.appState.userDetailStates[instanceId]!
    }

    var model: UserDetailInfo {
        state.model
    }
    
    private var shouldHideNavbar: Bool {
        let hideNavbar =  scrollY > -heightOfNodeImage * 1.0
        statusBarConfigurator.statusBarStyle = hideNavbar ? .lightContent : .darkContent
        return hideNavbar
    }
    
    var foreGroundColor: Color {
        shouldHideNavbar ? .white.opacity(0.9) : .tintColor
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            navBar
                .zIndex(1)
            VStack(spacing: 0) {
                topBannerView
                    .readSize {
                        bannerViewHeight = $0.height
                    }
                tabsTitleView
                topicDetailView
            }
            .updatable(autoRefresh: state.showProgressView) {
                await run(action: UserDetailActions.FetchData.Start(id: instanceId, userId: self.userId))
            } onScroll: {
                self.scrollY = $0
            }
            .background {
                VStack(spacing: 0) {
//                    KFImage
//                        .url(URL(string: model.avatar))
                    Image("avar")
                        .resizable()
                        .blur(radius: 80, opaque: true)
                        .overlay(Color.black.opacity(withAnimation {shouldHideNavbar ? 0.3 : 0.1}))
                        .frame(height: bannerViewHeight * 1.2 + max(scrollY, 0))
                    Spacer().background(.clear)
                }
//                .debug()
            }
        }
        .prepareStatusBarConfigurator(statusBarConfigurator)
        .buttonStyle(.plain)
        .ignoresSafeArea(.container)
        .navigationBarHidden(true)
        .onAppear {
            dispatch(action: UserDetailActions.FetchData.Start(id: instanceId, userId: userId))
        }
        .onDisappear {
            if !isPresented {
                log("onPageClosed----->")
                statusBarConfigurator.statusBarStyle = .darkContent
                dispatch(action: InstanceDestoryAction(target: .userdetail, id: instanceId))
            }
        }
    }
    
    @ViewBuilder
    private var navBar: some View  {
        NavbarHostView(paddingH: 0) {
            HStack(alignment: .center, spacing: 4) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.title2.weight(.regular))
                        .padding(.leading, 8)
                        .padding(.vertical, 10)
                }
                .forceClickable()
                
                Group {
                    AvatarView(url: model.avatar, size: 36)
                        .overlay {
                            Circle()
                                .fill(.green)
                                .frame(width: 8, height: 8)
                                .offset(x: 9, y: 36/2 - 2)
                        }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(model.userName)
                            .font(.headline)
                        Text(model.desc)
                            .font(.subheadline)
                        //                        Circle().fill(.green).frame(width: 8, height: 8)
                    }
                    .lineLimit(1)
                }
                .opacity(shouldHideNavbar ? 0.0 : 1.0)
                
                Spacer()
                
                Button {
                    // Star the node
                } label: {
                    Image(systemName: "heart")
                        .padding(8)
                        .font(.title3.weight(.regular))
                }
                .opacity(shouldHideNavbar ? 0.0 : 1.0)
                .forceClickable()
                
                Button {
                    // block user
                } label: {
                    Image(systemName: "eye.slash")
                        .padding(8)
                        .font(.body.weight(.regular))
                }
                .forceClickable()
            }
            .padding(.vertical, 5)
        }
        .hideDivider(hide: shouldHideNavbar)
        .foregroundColor(foreGroundColor)
        .visualBlur(alpha: shouldHideNavbar ? 0.0 : 1.0)
    }
    
    @ViewBuilder
    private var topBannerView: some View {
        VStack (spacing: 14) {
            Color.clear.frame(height: topSafeAreaInset().top)
            AvatarView(url: model.avatar, size: heightOfNodeImage)
            HStack(alignment: .center,spacing: 4) {
                Circle().fill(.green).frame(width: 8, height: 8)
                Text(model.userName)
                    .font(.headline.weight(.semibold))
            }
            Button {
                // do star
            } label: {
                Text("关注")
                    .font(.callout)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 2)
                    .roundedEdge(radius: 99, borderWidth: 1, color: foreGroundColor)
            }
            Text(model.desc)
                .font(.callout)
        }
        .foregroundColor(foreGroundColor)
        .padding(.vertical, 8)
    }
    
    private var tabsTitleView: some View {
        HStack(spacing: 0) {
            TabButton(title: "主题", id: .topic, selectedID: $currentTab, animation: self.animation)
            TabButton(title: "回复", id: .reply, selectedID: $currentTab, animation: self.animation)
        }
        .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }
    
    @ViewBuilder
    private var topicDetailView: some View {
        VStack(spacing: 0) {
//            ForEach( 0...20, id: \.self) { i in
//                NavigationLink(destination: NewsDetailPage()) {
//                    NewsItemView()
//                }
//            }
        }
        .background(.white)
    }
}

struct TabButton: View {
    
    public enum ID: String {
        case topic, reply
    }
    
    var title: String
    var id: ID
    @Binding var selectedID: ID
    var animation: Namespace.ID
    
    
    var isSelected: Bool {
        return id == selectedID
    }
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                selectedID = id
            }
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white.opacity(0.9) : .tintColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background {
                    VStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                }
                .forceClickable()
        }
    }
    
}

//struct UserDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailPage()
//    }
//}
