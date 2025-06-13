import SwiftUI
import UserNotifications

struct ProfileView: View {
    @State private var notificationPermissionStatus: UNAuthorizationStatus = .notDetermined
    @State private var wakeUpTime = Calendar.current.date(from: DateComponents(hour: 6, minute: 30)) ?? Date()
    @State private var bedTime = Calendar.current.date(from: DateComponents(hour: 22, minute: 15)) ?? Date()
    @State private var showingWakeUpPicker = false
    @State private var showingBedTimePicker = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Header Section
                Section {
                    HStack {
                        // Profile Image
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Profile")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Manage your daily routine settings")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                // Sleep Schedule Section
                Section {
                    // Wake Up Time
                    HStack {
                        Image(systemName: "sunrise.fill")
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Wake Up")
                                .font({
                                    if #available(iOS 16.0, *) {
                                        return .system(.body, weight: .medium)
                                    } else {
                                        return Font.body.weight(.medium)
                                    }
                                }())
                            Text("Start your day")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingWakeUpPicker = true
                        }) {
                            Text(wakeUpTime.formatted(date: .omitted, time: .shortened))
                                .font({
                                    if #available(iOS 16.0, *) {
                                        return .system(.body, weight: .medium)
                                    } else {
                                        return Font.body.weight(.medium)
                                    }
                                }())
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Bed Time
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.indigo)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Bed Time")
                                .font({
                                    if #available(iOS 16.0, *) {
                                        return .system(.body, weight: .medium)
                                    } else {
                                        return Font.body.weight(.medium)
                                    }
                                }())
                            Text("Wind down for sleep")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingBedTimePicker = true
                        }) {
                            Text(bedTime.formatted(date: .omitted, time: .shortened))
                                .font({
                                    if #available(iOS 16.0, *) {
                                        return .system(.body, weight: .medium)
                                    } else {
                                        return Font.body.weight(.medium)
                                    }
                                }())
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                    
                } header: {
                    Text("Sleep Schedule")
                } footer: {
                    Text("Set your ideal wake up and bed times to optimize your daily routine.")
                }
                
                // Notification Settings Section
                Section {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.red)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Notifications")
                                .font({
                                    if #available(iOS 16.0, *) {
                                        return .system(.body, weight: .medium)
                                    } else {
                                        return Font.body.weight(.medium)
                                    }
                                }())
                            Text(notificationStatusText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if notificationPermissionStatus == .denied {
                            Button("Settings") {
                                openAppSettings()
                            }
                            .font({
                                if #available(iOS 16.0, *) {
                                    return .system(.body, weight: .medium)
                                } else {
                                    return Font.body.weight(.medium)
                                }
                            }())
                            .foregroundColor(.blue)
                        } else if notificationPermissionStatus == .notDetermined {
                            Button("Enable") {
                                requestNotificationPermissions()
                            }
                            .font({
                                if #available(iOS 16.0, *) {
                                    return .system(.body, weight: .medium)
                                } else {
                                    return Font.body.weight(.medium)
                                }
                            }())
                            .foregroundColor(.blue)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 8)
                    
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Receive reminders 15 minutes before and at the exact time of each routine item.")
                }
                
                // App Information Section
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("App Version")
                                .font({
                                    if #available(iOS 16.0, *) {
                                        return .system(.body, weight: .medium)
                                    } else {
                                        return Font.body.weight(.medium)
                                    }
                                }())
                            Text("1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                checkNotificationPermissionStatus()
            }
        }
        .sheet(isPresented: $showingWakeUpPicker) {
            NavigationView {
                VStack {
                    DatePicker("Wake Up Time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle("Wake Up Time")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showingWakeUpPicker = false
                            saveScheduleSettings()
                        }
                        .font({
                            if #available(iOS 16.0, *) {
                                return .system(.body, weight: .semibold)
                            } else {
                                return Font.body.weight(.semibold)
                            }
                        }())
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingWakeUpPicker = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingBedTimePicker) {
            NavigationView {
                VStack {
                    DatePicker("Bed Time", selection: $bedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle("Bed Time")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showingBedTimePicker = false
                            saveScheduleSettings()
                        }
                        .font({
                            if #available(iOS 16.0, *) {
                                return .system(.body, weight: .semibold)
                            } else {
                                return Font.body.weight(.semibold)
                            }
                        }())
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingBedTimePicker = false
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var notificationStatusText: String {
        switch notificationPermissionStatus {
        case .authorized:
            return "Enabled"
        case .denied:
            return "Disabled - Tap to open Settings"
        case .notDetermined:
            return "Not set up"
        case .provisional:
            return "Enabled (Quiet)"
        case .ephemeral:
            return "Enabled (Temporary)"
        @unknown default:
            return "Unknown"
        }
    }
    
    // MARK: - Methods
    
    private func checkNotificationPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationPermissionStatus = settings.authorizationStatus
            }
        }
        
        loadScheduleSettings()
    }
    
    private func requestNotificationPermissions() {
        NotificationManager.shared.requestNotificationPermissions()
        
        // Check status again after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            checkNotificationPermissionStatus()
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func saveScheduleSettings() {
        UserDefaults.standard.set(wakeUpTime, forKey: "wakeUpTime")
        UserDefaults.standard.set(bedTime, forKey: "bedTime")
        
        print("💾 Saved schedule settings - Wake up: \(wakeUpTime.formatted(date: .omitted, time: .shortened)), Bed time: \(bedTime.formatted(date: .omitted, time: .shortened))")
    }
    
    private func loadScheduleSettings() {
        if let savedWakeUpTime = UserDefaults.standard.object(forKey: "wakeUpTime") as? Date {
            wakeUpTime = savedWakeUpTime
        }
        
        if let savedBedTime = UserDefaults.standard.object(forKey: "bedTime") as? Date {
            bedTime = savedBedTime
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
} 