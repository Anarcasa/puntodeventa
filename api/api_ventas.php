<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once '../config/database.php';

$db = getDB();

if (!isset($_GET['id'])) {
    echo json_encode(['error' => 'Falta el parámetro id']);
    exit;
}

$saleId = intval($_GET['id']);

// Obtener la venta principal
$stmt = $db->prepare("SELECT * FROM ventas WHERE id = ?");
$stmt->execute([$saleId]);
$sale = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$sale) {
    echo json_encode(['error' => 'Venta no encontrada']);
    exit;
}

// Obtener el detalle de productos de la venta
$stmt = $db->prepare("
    SELECT dv.producto_id, dv.cantidad, dv.subtotal, dv.personalizacion, p.nombre AS producto_nombre
    FROM detalle_ventas dv
    JOIN productos p ON dv.producto_id = p.id
    WHERE dv.venta_id = ?
");
$stmt->execute([$saleId]);
$detalles = $stmt->fetchAll(PDO::FETCH_ASSOC);

$items = [];
foreach ($detalles as $detalle) {
    $items[] = [
        'product_id'    => $detalle['producto_id'],
        'product_name'  => $detalle['producto_nombre'],
        'quantity'      => $detalle['cantidad'],
        'total_price'   => $detalle['subtotal'],
        'ingredients'   => json_decode($detalle['personalizacion'], true) ?: []
    ];
}

echo json_encode([
    'id' => $sale['id'],
    'fecha_venta' => $sale['fecha_venta'],
    'total' => $sale['total'],
    'pago_recibido' => $sale['pago_recibido'],
    'cambio' => $sale['cambio'],
    'estado' => $sale['estado'],
    'items' => $items
]);
?>