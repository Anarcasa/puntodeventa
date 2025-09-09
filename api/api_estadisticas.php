<?php
// api/estadisticas.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

require_once '../config/database.php';
require_once '../classes/venta.php';

try {
    $venta = new Venta();
    
    $estadisticas = [
        'today' => $venta->obtenerVentasDelDia(),
        'weekly' => $venta->obtenerVentasSemanales(),
        'monthly' => $venta->obtenerVentasMensuales(),
        'recent_sales' => $venta->obtenerUltimas(10)
    ];
    
    // Formatear números para el frontend
    if ($estadisticas['today']) {
        $estadisticas['today']['ingresos_totales'] = number_format(
            (float)$estadisticas['today']['ingresos_totales'], 2, '.', ''
        );
    }
    
    foreach ($estadisticas['weekly'] as &$week) {
        $week['ingresos_totales'] = number_format(
            (float)$week['ingresos_totales'], 2, '.', ''
        );
    }
    
    foreach ($estadisticas['monthly'] as &$month) {
        $month['ingresos_totales'] = number_format(
            (float)$month['ingresos_totales'], 2, '.', ''
        );
    }
    
    foreach ($estadisticas['recent_sales'] as &$sale) {
        $sale['total'] = number_format((float)$sale['total'], 2, '.', '');
        $sale['pago_recibido'] = number_format((float)$sale['pago_recibido'], 2, '.', '');
        $sale['cambio'] = number_format((float)$sale['cambio'], 2, '.', '');
    }
    
    echo json_encode($estadisticas, JSON_UNESCAPED_UNICODE);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Error del servidor',
        'message' => $e->getMessage()
    ]);
}
?>