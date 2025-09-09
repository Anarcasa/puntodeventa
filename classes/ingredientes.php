<?php
// classes/Ingrediente.php
require_once '../config/database.php';

class Ingrediente {
    private $conn;
    
    public function __construct() {
        $this->conn = getDB();
    }
    
    // Obtener todos los ingredientes disponibles
    public function obtenerTodos() {
        try {
            $query = "SELECT * FROM ingredientes WHERE disponible = 1 ORDER BY tipo, nombre";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt->fetchAll();
        } catch(PDOException $e) {
            return [];
        }
    }
    
    // Obtener ingredientes agrupados por tipo
    public function obtenerAgrupados() {
        try {
            $ingredientes = $this->obtenerTodos();
            $agrupados = [];
            
            foreach($ingredientes as $ingrediente) {
                $tipo = ucfirst($ingrediente['tipo']);
                if(!isset($agrupados[$tipo])) {
                    $agrupados[$tipo] = [];
                }
                $agrupados[$tipo][] = $ingrediente;
            }
            
            return $agrupados;
        } catch(Exception $e) {
            return [];
        }
    }
    
    // Obtener ingrediente por ID
    public function obtenerPorId($id) {
        try {
            $query = "SELECT * FROM ingredientes WHERE id = :id AND disponible = 1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
            return $stmt->fetch();
        } catch(PDOException $e) {
            return null;
        }
    }
    
    // Obtener ingredientes por IDs (para cálculo de precios)
    public function obtenerPorIds($ids) {
        try {
            if(empty($ids)) return [];
            
            $placeholders = str_repeat('?,', count($ids) - 1) . '?';
            $query = "SELECT * FROM ingredientes WHERE id IN ($placeholders) AND disponible = 1";
            $stmt = $this->conn->prepare($query);
            $stmt->execute($ids);
            return $stmt->fetchAll();
        } catch(PDOException $e) {
            return [];
        }
    }
}
?>