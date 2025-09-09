<?php
// classes/Venta.php
require_once '../config/database.php';

class Venta
{
    private $conn;

    public function __construct()
    {
        $this->conn = getDB();
    }

    // Crear nueva venta
    public function crear($productos, $total, $pago_recibido)
    {
        try {
            $this->conn->beginTransaction();

            $cambio = $pago_recibido - $total;

            // Insertar venta
            $query = "INSERT INTO ventas (total, pago_recibido, cambio, estado) VALUES (?, ?, ?, 'completado')";
            $stmt = $this->conn->prepare($query);
            $stmt->execute([$total, $pago_recibido, $cambio]);

            $venta_id = $this->conn->lastInsertId();

            // Insertar detalles de la venta
            foreach ($productos as $producto) {
                $query = "INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal, personalizacion) 
                         VALUES (?, ?, ?, ?, ?, ?)";
                $stmt = $this->conn->prepare($query);
                $stmt->execute([
                    $venta_id,
                    $producto['id'],
                    $producto['cantidad'],
                    $producto['precio_unitario'],
                    $producto['subtotal'],
                    json_encode($producto['ingredientes'])
                ]);
            }

            $this->conn->commit();
            return $venta_id;
        } catch (Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Obtener ventas del día
    public function obtenerVentasDelDia()
    {
        try {
            $query = "SELECT * FROM ventas_del_dia";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetch();
        } catch (PDOException $e) {
            return null;
        }
    }

    // Obtener ventas de la semana
    public function obtenerVentasSemanales()
    {
        try {
            $query = "SELECT * FROM ventas_semanales";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }

    // Obtener ventas del mes
    public function obtenerVentasMensuales()
    {
        try {
            $query = "SELECT * FROM ventas_mensuales";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }

    // Obtener detalle de una venta específica
    public function obtenerDetalle($venta_id)
    {
        try {
            $query = "SELECT v.*, dv.*, p.nombre as producto_nombre, p.descripcion 
                     FROM ventas v 
                     JOIN detalle_ventas dv ON v.id = dv.venta_id 
                     JOIN productos p ON dv.producto_id = p.id 
                     WHERE v.id = ?";
            $stmt = $this->conn->prepare($query);
            $stmt->execute([$venta_id]);
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }

    // Obtener últimas ventas
    public function obtenerUltimas($limit = 10)
    {
        try {
            $limit = intval($limit); // Seguridad: convertir a entero
            $query = "SELECT * FROM ventas WHERE estado = 'completado' ORDER BY fecha_venta DESC LIMIT $limit";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch (PDOException $e) {
            return [];
        }
    }
}
