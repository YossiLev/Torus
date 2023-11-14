import SwiftUI

struct ContentView: View {
    @State var torusIndex = 0
    @State var playStatus = true
    var body: some View {
        ZStack {
            TorusView(torusIndex: $torusIndex, playStatus: $playStatus)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        playStatus.toggle()
                    }, label: {Image(systemName: (playStatus ? "pause" : "play"))
                            .font(.system(size: 64))
                            .foregroundColor(.blue)
                    })
                }
                Spacer()
                HStack {
                    ForEach(0..<6) { index in
                        Button(action: {
                            torusIndex = index
                        }, label: {Image(systemName: "\(index + 1).lane")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                        })
                    }
                    Button(action: {
                        torusIndex = 6
                    }, label: {Image(systemName: "circle")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                    })
                    Button(action: {
                        torusIndex = 7
                    }, label: {Image(systemName: "square")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                    })
                }
            }

        }
    }
}
