//
//  BatteryView.swift
//  ControlRoom
//
//  Created by Paul Hudson on 12/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

/// Controls the battery level and state for the whole device.
struct BatteryView: View {
    /// The current battery level of the device, as a value from 0 through 100
    @State private var batteryLevel = 100.0

    /// The current battery state of the device; must be "Charging", "Charged", or "Discharging"
    /// Note: "Charged" looks the same as "Discharging", so it's not included in this screen.
    @State private var batteryState = "Charging"

    var simulator: Simulator

    var body: some View {
        Form {
            Picker("State:", selection: $batteryState.onChange(updateBattery)) {
                ForEach(["Charging", "Discharging"], id: \.self) { state in
                    Text(state)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            Slider(value: $batteryLevel, in: 0...100, onEditingChanged: levelChanged, minimumValueLabel: Text("0%"), maximumValueLabel: Text("100%")) {
                Text("Level:")
            }

            Spacer()
        }
        .tabItem {
            Text("Battery")
        }
        .padding()
    }

    /// Sends battery updates all at once; simctl gets unhappy if we send them individually.
    func updateBattery() {
        Command.simctl("status_bar", self.simulator.udid, "override",
                       "--batteryLevel", "\(Int(self.batteryLevel))",
                       "--batteryState", batteryState.lowercased())
    }

    func levelChanged(_ editing: Bool) {
        if editing == false {
            self.updateBattery()
        }
    }
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView(simulator: .example)
    }
}
