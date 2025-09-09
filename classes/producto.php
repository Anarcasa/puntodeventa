<?php
// classes/Producto.php
require_once '../config/database.php';

class Producto {
    private $conn;
    
    public function __construct() {
        $this->conn = getDB();
    }
    
    // Obtener todos los productos activos
    public function obtenerTodos() {
        try {
            $query = "SELECT * FROM productos WHERE activo = 1 ORDER BY tipo, categoria, nombre";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Obtener productos por tipo
    public function obtenerPorTipo($tipo) {
        try {
            $query = "SELECT * FROM productos WHERE tipo = :tipo AND activo = 1 ORDER BY categoria, nombre";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':tipo', $tipo);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Obtener un producto específico
    public function obtenerPorId($id) {
        try {
            $query = "SELECT * FROM productos WHERE id = :id AND activo = 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return $stmt->fetch();
        } catch(PDOException $e) {
            return null;
        }
    }
    
    // Obtener productos agrupados por tipo
    public function obtenerAgrupados() {
        try {
            $productos = $this->obtenerTodos();
            $agrupados = [];
            
            foreach($productos as $producto) {
                $tipo = ucfirst($producto['tipo']);
                if(!isset($agrupados[$tipo])) {
                    $agrupados[$tipo] = [];
                }
                $agrupados[$tipo][] = $producto;
            }
            
            return $agrupados;
        } catch(Exception $e) {
            return [];
        }
    }
    
    // Calcular precio con ingredientes adicionales
    public function calcularPrecio($producto_id, $ingredientes_seleccionados = []) {
        try {
            // Obtener precio base del producto
            $producto = $this->obtenerPorId($producto_id);
            if(!$producto) return 0;
            
            $precio_total = floatval($producto['precio_base']);
            
            // Agregar precios de ingredientes adicionales
            if(!empty($ingredientes_seleccionados)) {
                $placeholders = str_repeat('?,', count($ingredientes_seleccionados) - 1) . '?';
                $query = "SELECT SUM(precio_extra) as extra FROM ingredientes WHERE id IN ($placeholders)";
                $stmt = $this->conn->prepare($query);
                $stmt->execute($ingredientes_seleccionados);
                $result = $stmt->fetch();
                
                if($result && $result['extra']) {
                    $precio_total += floatval($result['extra']);
                }
            }
            
            return $precio_total;
        } catch(Exception $e) {
            return 0;
        }
    }
}
?>