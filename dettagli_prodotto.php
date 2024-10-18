<?php
include 'connect.php';

if (isset($_GET['id'])) {
    $good_id = $_GET['id'];

    $query = "SELECT * FROM good WHERE good_id = $good_id";
    $result = $conn->query($query);
    if ($result->num_rows > 0) {
        $good = $result->fetch_assoc();
    } else {
        echo "<p>Articolo non trovato.</p>";
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettagli Prodotto</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class='container'>
    <h1><?php echo $good['name']; ?></h1>
    <p>Prezzo di Vendita: <?php echo $good['selling_price']; ?> €</p>
    <p>Prezzo di Acquisto: <?php echo $good['purchase_price']; ?> €</p>

    <a href="home.php" class="button">Torna alla Home</a>

    <h2>Seleziona quantità e visualizza i fornitori disponibili</h2>
    <form method="POST" action="">
        <input type="number" name="quantity" placeholder="Inserisci quantità" required min="1" onkeypress="return event.charCode >= 48 && event.charCode <= 57">
        <input class="button" type="submit" value="Calcola">
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $quantity = $_POST['quantity'];

        $query = "
            SELECT s.supplier_id, s.name, s.min_days_to_ship, st.quantita, s.discount_total_value_ind, s.discount_on_quantity_ind, s.discount_date_season_ind, g.purchase_price 
            FROM supplier s
            JOIN stock st ON s.supplier_id = st.supplier_id
            JOIN good g ON st.good_id = g.good_id
            WHERE g.good_id = $good_id AND st.quantita >= $quantity";
        
        $result = $conn->query($query);
        
        $best_price = PHP_INT_MAX;
        $best_days = PHP_INT_MAX;
        $best_price_supplier = '';
        $best_days_supplier = '';

        if ($result->num_rows > 0) {
            echo "<table class='styled-table'><tr><th>Fornitore</th><th>Prezzo Iniziale</th><th>Valore Sconto (%)</th><th>Prezzo Scontato</th><th>Giorni di Spedizione</th><th>Quantità Disponibile</th><th>Acquista</th></tr>";

            while ($supplier = $result->fetch_assoc()) {
                $original_price = $supplier['purchase_price'] * $quantity;
                $price = $original_price;
                $discount_applied = 0;

                if ($supplier['discount_total_value_ind']) {
                    $discount = json_decode($supplier['discount_total_value_ind'], true);
                    if ($original_price >= $discount['threshold']) {
                        $discount_applied += $discount['discount'];
                        $price -= $price * ($discount['discount'] / 100);
                    }
                }
                if ($supplier['discount_on_quantity_ind']) {
                    $discounts = json_decode($supplier['discount_on_quantity_ind'], true);
                    foreach ($discounts as $disc) {
                        if ($quantity >= $disc['quantity_threshold']) {
                            $discount_applied += $disc['discount'];
                            $price -= $price * ($disc['discount'] / 100);
                        }
                    }
                }

                if ($price < $best_price) {
                    $best_price = $price;
                    $best_price_supplier = $supplier['name'];
                }
                if ($supplier['min_days_to_ship'] < $best_days) {
                    $best_days = $supplier['min_days_to_ship'];
                    $best_days_supplier = $supplier['name'];
                }

                echo "<tr>
                        <td>{$supplier['name']}</td>
                        <td>{$original_price} €</td>
                        <td>{$discount_applied}%</td>
                        <td>{$price} €</td>
                        <td>{$supplier['min_days_to_ship']} giorni</td>
                        <td>{$supplier['quantita']}</td>
                        <td>
                            <form method='POST' action=''>
                                <input type='hidden' name='supplier_id' value='{$supplier['supplier_id']}'>
                                <input type='hidden' name='good_id' value='$good_id'>
                                <input type='hidden' name='quantity' value='$quantity'>
                                <input class='button' type='submit' name='purchase' value='Acquista'>
                            </form>
                        </td>
                    </tr>";
            }

            echo "</table>";

            echo "<p><strong>Migliore opzione di acquisto per prezzo:</strong> $best_price_supplier a $best_price €.</p>";
            echo "<p><strong>Migliore opzione di acquisto per giorni di spedizione:</strong> $best_days_supplier in $best_days giorni.</p>";

            if (isset($_POST['purchase'])) {
                $supplier_id = $_POST['supplier_id'];
                $total_price = $price;

                $check_query = "SELECT * FROM acquistare WHERE shop_id = 1 AND good_id = $good_id";
                $check_result = $conn->query($check_query);

                if ($check_result->num_rows > 0) {
                    echo "<p>Questo prodotto è già stato acquistato.</p>";
                } else {
                    $update_stock_query = "UPDATE stock SET quantita = quantita - $quantity WHERE supplier_id = $supplier_id AND good_id = $good_id";
                    
                    if ($conn->query($update_stock_query) === TRUE) {
                        $insert_query = "INSERT INTO acquistare (shop_id, good_id) VALUES (1, $good_id)"; 

                        if ($conn->query($insert_query) === TRUE) {
                            echo "<p>Acquisto effettuato con successo!</p>";
                        } else {
                            echo "<p>Errore nell'acquisto: " . $conn->error . "</p>";
                        }
                    } else {
                        echo "<p>Errore nell'aggiornamento dello stock: " . $conn->error . "</p>";
                    }
                }
            }
        } else {
            echo "<p>Nessun fornitore disponibile per questa quantità.</p>";
        }
    }
    ?>

</div>

</body>
</html>
