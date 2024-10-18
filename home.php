<?php
include 'connect.php';
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Articoli Disponibili</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<?php
$query = "SELECT * FROM good";
$result = $conn->query($query);

echo "<div class='container'>";
if ($result && $result->num_rows > 0) {
    echo "<h1>Articoli Disponibili</h1>";
    echo "<table class='styled-table'><tr><th>Nome</th><th>Prezzo di Vendita</th><th>Dettagli</th></tr>";
    while($row = $result->fetch_assoc()) {
        echo "<tr><td>{$row['name']}</td><td>" . number_format($row['selling_price'], 2) . " €</td>";
        echo "<td><a class='button' href='dettagli_prodotto.php?id={$row['good_id']}'>Visualizza Dettagli</a></td></tr>";
    }
    echo "</table>";
} else {
    echo "<p>Nessun articolo disponibile.</p>";
}


echo "</div>";

$conn->close();
?>

</body>
</html>
