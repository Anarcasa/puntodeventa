<?php
// api/productos.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once '../config/database.php';
require_once '../classes/producto.php';

try {
    $producto = new Producto();
    
    // Verificar si se solicita un tipo específico
    $tipo = isset($_GET['tipo']) ? $_GET['tipo'] : null;
    
    if ($tipo && in_array($tipo, ['hamburguesa', 'torta', 'perro'])) {
        $productos = $producto->obtenerPorTipo($tipo);
    } else {
        $productos = $producto->obtenerTodos();
    }
    
    // Formatear precios para el frontend
    foreach ($productos as &$prod) {
        $prod['precio_base'] = number_format((float)$prod['precio_base'], 2, '.', '');
    }
    
    echo json_encode($productos, JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error del servidor',
        'message' => $e->getMessage()
    ]);
}
?>