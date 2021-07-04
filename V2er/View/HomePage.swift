//
//  Home.swift
//  V2er
//
//  Created by Seth on 2020/5/25.
//  Copyright © 2020 lessmore.io. All rights reserved.
//

import SwiftUI

struct HomePage: View {
    @State var selectedId = TabId.feed
    
    var body: some View {
        LazyVStack {
            ForEach( 0...60, id: \.self) { i in
                Text(" LineLineLineLineLineLineLineLineLine Number \(i)   ")
                    .background(i % 5 == 0 ? Color.blue : Color.clear)
            }
        }
        .updatable(
            refresh:{
            print("onRefresh...")
            let result = await fetchData()
            print("onRefresh ended...")
        }
            ,
            loadMore: {
            print("onLoadMore...")
            let result = await fetchData()
            return true
        }
            
        )
    }
    
    
    private func fetchData() async -> [String] {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let persons = [
                    "new Person 1",
                    "new Person 2",
                    "new Person 3",
                    "new Person 4"
                ]
                continuation.resume(returning: persons)
            }
            
        }
    }
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage()
        }
    }
}
