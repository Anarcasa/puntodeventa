<?php
// api/ingredientes.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once '../config/database.php';
require_once '../classes/ingredientes.php';

try {
    $ingrediente = new Ingrediente();
    $ingredientes = $ingrediente->obtenerTodos();
    
    // Formatear precios para el frontend
    foreach ($ingredientes as &$ing) {
        $ing['precio_extra'] = number_format((float)$ing['precio_extra'], 2, '.', '');
    }
    
    echo json_encode($ingredientes, JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error del servidor',
        'message' => $e->getMessage()
    ]);
}
?>