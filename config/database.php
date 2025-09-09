<?php
// config/database.php - Configuración de la base de datos
class Database {
    private $host = "localhost";
    private $db_name = "punto_venta_alimentos";
    private $username = "root"; // Cambiar según tu configuración
    private $password = "";     // Cambiar según tu configuración
    private $conn;

    public function getConnection() {
        $this->conn = null;
        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=utf8mb4",
                $this->username,
                $this->password,
                array(
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"
                )
            );
        } catch(PDOException $exception) {
            echo "Error de conexión: " . $exception->getMessage();
        }
        return $this->conn;
    }
}

// Función para obtener conexión global
function getDB() {
    $database = new Database();
    return $database->getConnection();
}
?>