import SwiftUI
import SceneKit

struct TorusView: UIViewRepresentable {
    @Binding var torusIndex: Int
    @Binding var playStatus: Bool
    
    let imageNames = ["T1", "T2", "T3", "T4", "T5", "T6", "check", "face"]
    
    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var torusNode: SCNNode?
        var pinchGesture: UIPinchGestureRecognizer?
        var scale = 1.0
        var startScale = 1.0
        var playStatus = true
        var rotation = SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0.1)

        override init() {
            super.init()
            print("init coordinator")
        }
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            
            if playStatus {
                // Rotate the torus
                rotation = SCNAction.rotateBy(x: 0, y: 0.04, z: 0, duration: 0.1)
                torusNode?.runAction(rotation)
            }
        }
        
        @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
            print("handlePinchGesture ")
            switch gesture.state {

            case .changed:
                print("handlePinchGesture \(gesture.scale)")
                scale = startScale * gesture.scale
                print("handlePinchGesture \(gesture.scale) \(scale)")
                torusNode?.scale = SCNVector3(x: Float(scale), y: Float(scale), z: Float(scale))
                break;
            case .ended:
                startScale = scale
                gesture.scale = 1.0 // Reset the scale to 1 after applying
                break;
            default:
                break
            }
        }
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()

        let torusNode = createTorus(rot: SCNVector3(x: .pi / 4, y: 0, z: .pi / 4))
        
        // Add the torus node to the scene
        sceneView.scene?.rootNode.addChildNode(torusNode)

        // Set up the delegate for updates
        sceneView.delegate = context.coordinator

        // Set an explicit frame
        //sceneView.frame = UIScreen.main.bounds
        sceneView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        
        // Save torusNode to the coordinator for later reference
        context.coordinator.torusNode = torusNode

        // Zoom out by adjusting the camera's position
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3) // Adjust the 'z' value for zoom
        
        sceneView.scene?.rootNode.addChildNode(cameraNode)

        // Set up pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, 
                    action: #selector(Coordinator.handlePinchGesture(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        context.coordinator.pinchGesture = pinchGesture
        context.coordinator.playStatus = playStatus
        
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        let rot = context.coordinator.torusNode?.eulerAngles
        
        let torusNode = createTorus(rot: rot ?? SCNVector3(x: .pi / 4, y: 0, z: .pi / 4))
            
        uiView.scene?.rootNode.replaceChildNode(context.coordinator.torusNode!, with: torusNode)
        
        context.coordinator.torusNode = torusNode
        context.coordinator.playStatus = playStatus
    }
    
    private func createTorus(rot: SCNVector3) -> SCNNode {
        // Create a torus geometry
        let torusNode = SCNNode(geometry: SCNTorus(ringRadius: 0.520, pipeRadius: 0.07))
        torusNode.name = "torusNode"
        
        // Set the orientation of the torus
        torusNode.eulerAngles = rot

        let boxNode = SCNNode(
            geometry: SCNBox(width: 0.3, height: 0.2, length: 0.3, chamferRadius: 0.01))
        boxNode.name = "boxNode"
        torusNode.addChildNode(boxNode)
       
        // Apply texture to the torus
        if let texture = UIImage(named: imageNames[torusIndex]) {
            let textureMaterial = SCNMaterial()
            textureMaterial.diffuse.contents = texture
            torusNode.geometry!.materials = [textureMaterial]
            boxNode.geometry!.materials = [textureMaterial]
        }
        
        return torusNode
    }
}
