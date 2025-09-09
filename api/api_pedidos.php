<?php
// api/pedido.php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../config/database.php';

try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Crear nuevo pedido
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (!$input) {
            throw new Exception('Datos inválidos');
        }
        
        $db = getDB();
        
        // Crear entrada en tabla de pedidos pendientes
        $query = "INSERT INTO pedidos_pendientes (datos_pedido, total, estado, fecha_creacion) VALUES (?, ?, 'pendiente', NOW())";
        $stmt = $db->prepare($query);
        
        $pedido_data = json_encode($input, JSON_UNESCAPED_UNICODE);
        $total = $input['total'];
        
        $stmt->execute([$pedido_data, $total]);
        $pedido_id = $db->lastInsertId();
        
        echo json_encode([
            'success' => true,
            'order_id' => $pedido_id,
            'message' => 'Pedido creado exitosamente'
        ]);
        
    } elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
        // Obtener pedidos pendientes
        $db = getDB();
        
        if (isset($_GET['id'])) {
            // Obtener pedido específico
            $query = "SELECT * FROM pedidos_pendientes WHERE id = ? AND estado = 'pendiente'";
            $stmt = $db->prepare($query);
            $stmt->execute([$_GET['id']]);
            $pedido = $stmt->fetch();
            
            if ($pedido) {
                $pedido['datos_pedido'] = json_decode($pedido['datos_pedido'], true);
                echo json_encode($pedido, JSON_UNESCAPED_UNICODE);
            } else {
                http_response_code(404);
                echo json_encode(['error' => 'Pedido no encontrado']);
            }
        } else {
            // Obtener todos los pedidos pendientes
            $query = "SELECT id, total, fecha_creacion FROM pedidos_pendientes WHERE estado = 'pendiente' ORDER BY fecha_creacion ASC";
            $stmt = $db->prepare($query);
            $stmt->execute();
            $pedidos = $stmt->fetchAll();
            
            echo json_encode($pedidos, JSON_UNESCAPED_UNICODE);
        }
    }
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error del servidor',
        'message' => $e->getMessage()
    ]);
}

// Crear tabla de pedidos pendientes si no existe
function crearTablaPedidosPendientes() {
    try {
        $db = getDB();
        $query = "CREATE TABLE IF NOT EXISTS pedidos_pendientes (
            id INT PRIMARY KEY AUTO_INCREMENT,
            datos_pedido JSON NOT NULL,
            total DECIMAL(10,2) NOT NULL,
            estado ENUM('pendiente', 'procesando', 'completado', 'cancelado') DEFAULT 'pendiente',
            fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )";
        $db->exec($query);
    } catch (Exception $e) {
        // Log error but don't stop execution
        error_log("Error creando tabla pedidos_pendientes: " . $e->getMessage());
    }
}

// Crear la tabla al cargar el archivo
crearTablaPedidosPendientes();
?>