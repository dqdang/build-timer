//
//  ContentView.swift
//  stargazing
//
//  Created by Derek Dang on 6/27/23.
//

import SwiftUI
import CoreData
import Model3DView
import Vision

struct ContentView: View {
    @State private var currentDate = Date()
    @State var camera = PerspectiveCamera()

    var buildDate: Date {
        let defaults = UserDefaults.standard
        if let storedDate = defaults.object(forKey: "BuildDate") as? Date {
            return storedDate
        } else {
            let initialBuildDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
            defaults.set(initialBuildDate, forKey: "BuildDate")
            return initialBuildDate
        }
    }

    var countdown: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: buildDate)

        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0

        return String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
    }

    var body: some View {
        VStack {
            Text("stargazing")
                .font(.title)
                .padding()

            Button(action: {
                resetBuildDate()
            }) {
                Text("Reset")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            Model3DView(named: "scene.gltf")
                .transform(
                    rotate: Euler(x: .degrees(271)),
                    scale: 0.5
                )
                .cameraControls(OrbitControls(
                        camera: $camera,
                        sensitivity: 0.8,
                        friction: 0.1
                    ))

            Text(countdown)
                .font(.largeTitle)
                .padding()
        }
        .onAppear {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentDate = Date()
            }
            RunLoop.current.add(timer, forMode: .common)
        }
    }

    func resetBuildDate() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "BuildDate")
        currentDate = Date()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
