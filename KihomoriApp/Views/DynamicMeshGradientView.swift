import SwiftUI

struct DynamicMeshGradientView: View {
    @State private var points: [SIMD2<Float>] = []
    @State private var colors: [Color] = []

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    print("Canvas size: \(size)") // サイズをデバッグ

                    let time = timeline.date.timeIntervalSinceReferenceDate
                    updatePoints(size: size, time: time)

                    // メッシュグラデーションの作成
                    guard points.count == colors.count else {
                        print("Points and colors count mismatch!")
                        return
                    }

                    let meshGradient = MeshGradient(
                        width: 3,
                        height: 3,
                        points: points,
                        colors: colors,
                        smoothsColors: true
                    )

                    context.fill(
                        Rectangle().path(in: CGRect(origin: .zero, size: size)),
                        with: .meshGradient(meshGradient)
                    )
                }
            }
            .onAppear {
                initializePointsAndColors(size: geometry.size)
            }
            .ignoresSafeArea()
        }
    }

    private func initializePointsAndColors(size: CGSize) {
        print("Initializing points and colors with size: \(size)") // 初期化デバッグ

        points = [
            SIMD2<Float>(0.2, 0.2),
            SIMD2<Float>(0.8, 0.2),
            SIMD2<Float>(0.5, 0.5),
            SIMD2<Float>(0.2, 0.8),
            SIMD2<Float>(0.8, 0.8)
        ]
        colors = [
            .red, .purple, .blue, .green, .yellow
        ]
    }

    private func updatePoints(size: CGSize, time: TimeInterval) {
        for i in points.indices {
            let baseX = points[i].x
            let baseY = points[i].y

            let offsetX = Float(sin(time + Double(i)) * 0.05)
            let offsetY = Float(cos(time + Double(i)) * 0.05)

            points[i] = SIMD2<Float>(
                clamp(value: baseX + offsetX, min: 0.0, max: 1.0),
                clamp(value: baseY + offsetY, min: 0.0, max: 1.0)
            )
        }
    }

    private func clamp(value: Float, min: Float, max: Float) -> Float {
        return Swift.max(min, Swift.min(max, value))
    }
}

#Preview {
    DynamicMeshGradientView()
}
