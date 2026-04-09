import SwiftUI

// -----------------------------
// Simple Notification Screen
// -----------------------------
// One file. Models + view + small row component.
// Preview is minimal for quick debugging.
// -----------------------------

struct MyNotificationScreen: View {
    // sample notifications (matches the screenshot layout)
    @State private var notifications: [NotificationItem] = [
        NotificationItem(title: "Product Booking Successful",
                         message: "Your car is ready! Check your email for the booking and pickup instructions. Safe travels!",
                         time: "10:00 am",
                         isUnread: true,
                         systemIcon: "checkmark.seal"),
        NotificationItem(title: "Product Pickup/Drop-off time",
                         message: "Pickup time confirmed! See you at [Time] for your car rental. Drop-off Time Confirmed!",
                         time: "09:00 am",
                         isUnread: false,
                         systemIcon: "clock"),
        NotificationItem(title: "Late Return Warning",
                         message: "Late Return Alert! Please return the car as soon as possible to avoid extra charges.",
                         time: "Yesterday",
                         isUnread: false,
                         systemIcon: "exclamationmark.triangle"),
        NotificationItem(title: "Cancellation Notice",
                         message: "Your Reservation Has Been Canceled or Booking Cancelled Successfully.",
                         time: "Yesterday",
                         isUnread: false,
                         systemIcon: "xmark.octagon")
    ]

    var body: some View {
        ZStack {
            // full screen background (light)
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 0) {
                // top rounded title area
                VStack {
                    // small top spacer so rounded card looks like screenshot
                    Spacer().frame(height: 8)
                    Text("Notification")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                    Divider()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)

                // content card (white rounded)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack(spacing: 12) {
                            // Today header + unread count (aligned like screenshot)
                            HStack {
                                Text("Today")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(notifications.filter { $0.isUnread }.count) Unread Notification")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .padding(.top, 6)

                            // list of today / main notifications
                            VStack(spacing: 8) {
                                ForEach(notifications.indices, id: \.self) { idx in
                                    // Show only first two as "Today" style like screenshot,
                                    // the rest we still show in same list to keep layout similar.
                                    NotificationRow(item: notifications[idx])
                                }
                            }
                            .padding(.horizontal, 8)

                            // small spacer then "Previous" header can be added if needed
                            // (screenshot shows later items with "Yesterday" text)
                        }
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, safeBottom() + 16)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func safeBottom() -> CGFloat {
        let w = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }.first?.windows.first
        return w?.safeAreaInsets.bottom ?? 0
    }
}

// single small model used by the view
fileprivate struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let isUnread: Bool
    let systemIcon: String
}

// single row implementation matching screenshot
fileprivate struct NotificationRow: View {
    let item: NotificationItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // icon square
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .frame(width: 46, height: 46)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06), lineWidth: 1))

                Image(systemName: item.systemIcon)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }

            // text content
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .lineLimit(2)

                    Spacer()

                    // time + unread dot
                    VStack(alignment: .trailing, spacing: 6) {
                        Text(item.time)
                            .font(.caption2)
                            .foregroundColor(.gray)

                        if item.isUnread {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                        } else {
                            // keep layout balanced: small empty space
                            Spacer().frame(height: 8)
                        }
                    }
                }

                Text(item.message)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.00), lineWidth: 0)
        )
    }
}

// preview — minimal and easy to debug
struct MyNotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyNotificationScreen()
            .previewDevice("iPhone 14 Pro")
    }
}
