<?php
$conn = new mysqli('localhost', 'root', 'root', 'regesta_test_ingresso_shop_db');


if ($conn->connect_error) {
    die("Connessione al database fallita: " . $conn->connect_error);
}
?>
