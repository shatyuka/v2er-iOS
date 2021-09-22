//
//  NewsItemView.swift
//  V2er
//
//  Created by Seth on 2021/7/4.
//  Copyright © 2021 lessmore.io. All rights reserved.
//

import SwiftUI

struct FeedItemView: View {
    var data: FeedInfo.Item
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    NavigationLink(destination: UserDetailPage(userId: data.userName)) {
                        AvatarView(url: data.avatar)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(data.userName)
                            .lineLimit(1)
                            .font(.body)
                        Text(data.replyUpdate)
                            .lineLimit(1)
                            .font(.footnote)
                            .foregroundColor(Color.tintColor)
                    }
                    Spacer()
                    NavigationLink(destination: TagDetailPage(tagId: data.tagId)) {
                        Text(data.tagName)
                            .font(.footnote)
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.lightGray)
                    }
                }
                Text(data.title )
                    .greedyWidth(.leading)
                    .lineLimit(2)
                    .padding(.vertical, 3)
                Text("评论\(data.replies)")
                    .font(.footnote)
                    .greedyWidth(.trailing)
            }
            .padding(12)
            Divider()
        }
        .background(Color.almostClear)
    }
}

//struct NewsItemView_Previews: PreviewProvider {
//    static var previews: some View {
////        NewsItemView()
//    }
//}
