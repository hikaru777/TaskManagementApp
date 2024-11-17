import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        locationManager.stopUpdatingLocation() // 取得後は更新を停止
    }
}

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // 地図の表示範囲を設定
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
        
        // 半径1kmの円オーバーレイを追加
        let circle = MKCircle(center: centerCoordinate, radius: 1000) // 半径1000メートル（1キロメートル）
        mapView.addOverlay(circle)
        
        // ピン（アノテーション）を追加
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 必要に応じて更新
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
                circleRenderer.strokeColor = UIColor.blue
                circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.3)
                circleRenderer.lineWidth = 2
                return circleRenderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
