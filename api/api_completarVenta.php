<?php
// api/completar_venta.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../config/database.php';
require_once '../classes/venta.php';

try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception('Método no permitido');
    }
    
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input || !isset($input['order_id'])) {
        throw new Exception('Datos inválidos');
    }
    
    $db = getDB();
    
    // Iniciar transacción
    $db->beginTransaction();
    
    // Preparar datos para la venta
    $productos_venta = [];
    foreach ($input['items'] as $item) {
        $productos_venta[] = [
            'id' => $item['product_id'],
            'cantidad' => $item['quantity'],
            'precio_unitario' => $item['unit_price'],
            'subtotal' => $item['total_price'],
            'ingredientes' => $item['ingredients'] ?? []
        ];
    }
    
    // Crear venta usando la clase Venta
    $venta = new Venta();
    $venta_id = $venta->crear(
        $productos_venta,
        $input['total'],
        $input['payment_received']
    );
    
    if (!$venta_id) {
        throw new Exception('Error al crear la venta');
    }
    
    // Marcar pedido como completado
    $query = "UPDATE pedidos_pendientes SET estado = 'completado', fecha_actualizacion = NOW() WHERE id = ?";
    $stmt = $db->prepare($query);
    $stmt->execute([$input['order_id']]);
    
    // Confirmar transacción
    $db->commit();
    
    echo json_encode([
        'success' => true,
        'venta_id' => $venta_id,
        'message' => 'Venta completada exitosamente'
    ]);
    
} catch (Exception $e) {
    // Revertir transacción en caso de error
    if (isset($db) && $db->inTransaction()) {
        $db->rollback();
    }
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error del servidor',
        'message' => $e->getMessage()
    ]);
}
?>