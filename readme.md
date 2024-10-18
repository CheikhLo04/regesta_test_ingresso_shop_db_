## Regesta Test d'ingresso

In questo README descriverò in modo dettagliato i passaggi che ho seguito per completare questo esercizio.

### Consegna - Purchase orders for stock replenishment

Your shop sells goods that you can buy from different suppliers. The selling price of each article is fixed, but you should be able to buy that article from one supplier instead of another depending on purchase price and discounts.

The discount percentage a supplier could offer can be related to the total order value, to the ordered quantity or could be limited to a particular date/season.

When you need to order an article, you choose an item and the quantity you want to buy; the system should find which suppliers do sell that article (check if enough quantity is available in stock) and calculate the total purchase order amount applying the discounts (if available). The result list should suggest the best supplier highlighting the cheapest one.

Also display the minimum days that each supplier needs to ship your order; this way you can choose that a faster supplier is still better than a cheaper one.

### Precisazione

Attualmente frequento il quarto anno serale del corso di informatica presso l'ITIS Castelli e non ho ancora affrontato alcuni degli argomenti necessari per svolgere l'esercizio. Tuttavia, alcuni di questi li ho già esplorati autonomamente attraverso progetti personali. Nei primi giorni ho condotto ricerche e studiato alcuni argomenti per acquisire le basi necessarie a completare l'esercizio correttamente. Allego di seguito le risorse utilizzate:

- [Database relazionale](https://www.oracle.com/it/database/what-is-a-relational-database/)
- [Progettazione di un database](https://ilprofdinformatica.altervista.org/classe5/db_progetto.htm)
- [MySQL](https://www.youtube.com/watch?v=5OdVJbNCSso)
- [PHP](https://www.youtube.com/watch?v=zZ6vybT1HQs)

### Step effettuati

<details close>
<summary>
Creazione Database
</summary> 
<br>
NB: si presume questo database gestisce solo le transazione di acquisti di articoli da parte del nostro shop dai fornitore e non le transazioni di vendita degli articoli ai clienti
  
#### Entità e relativi attributi
- Shop: shop_id - name - via - civico - citta - nazione
- Good: good_id - name - selling_price (prezzo di vendita fisso) - purchase_price (in questo caso, il prezzo rappresenta il prezzo di vendita del prodotto da parte del fornitore)
- Supplier: supplier_id - name - discount_total_value_ind (JSON con le indicazioni su come effettutre lo sconto) - discount_on_quantity_ind (JSON con le indicazioni su come effettutre lo sconto) - discount_date_season_ind (JSON con le indicazioni su come effettutre lo sconto) - min_days_to_ship (questo attributo può essere nullo)
- Stock: stock_id - quantita

### Cardinalità

- Good-Supplier => N:N (FORNIRE): un articolo può essere fornito da più fornitori, e un fornitore può offrire più articoli.
- Supplier-Stock => 1:N (GESTIRE): un fornitore può gestire più scorte di diversi prodotti, mentre una scorta specifica è gestita da un unico fornitore.
- Good-Stock => 1:N (CONTENERE): un articolo può essere presente in più scorte gestite da diversi fornitori, mentre una specifica scorta contiene un solo articolo (in quantità variabile)
- Shop-Good => N:N (ACQUISTARE): Un negozio può acquistare più articoli, mentre un articolo può essere acquistato da un più negozi

### Schema logico

- shop (`shop_id` - name - via - civico - citta - nazione)
- Good (`good_id` - name - selling_price - purchase_price)
- Supplier (`supplier_id` - name - discount_total_value_ind - discount_on_quantity_ind - discount_date_season_ind - min_days_to_ship)
- Stock (`stock_id` - quantita - supplier_id (FK) - good_id (FK))
- FORNIRE (`good_id` (FK) - `supplier_id` (FK))
- ACQUISTARE (`shop_id` (FK) - `good_id` (FK))

</details>

<details close>
<summary>
Implementazione
  Connessione al Database:
Il primo passo è stato creare una connessione tra il progetto PHP e il database MySQL attraverso un file separato per la connessione. Questo file permette al sistema di comunicare con il database per eseguire operazioni come la ricerca dei fornitori, l'inserimento degli ordini e l'aggiornamento delle scorte.
Recupero dei Fornitori per un Articolo:
Quando l'utente seleziona un articolo e la quantità da ordinare, il sistema recupera tutti i fornitori che vendono quell'articolo, cercando nel database i fornitori con sufficiente disponibilità in stock. Durante questa operazione vengono recuperate anche altre informazioni, come il prezzo d'acquisto, eventuali sconti e i tempi di spedizione.
Applicazione degli Sconti:
I fornitori possono offrire sconti che dipendono dal totale dell'ordine, dalla quantità acquistata o da periodi stagionali specifici. Ho implementato una logica che verifica questi parametri per ogni fornitore e applica gli sconti disponibili al calcolo del prezzo finale.
Calcolo del Totale e Suggerimento del Fornitore:
Una volta applicati gli sconti, il sistema calcola il costo totale dell'ordine per ogni fornitore e mostra una lista di risultati all'utente. Questa lista suggerisce il fornitore più economico e visualizza i tempi di spedizione minimi, permettendo all'utente di scegliere tra una consegna più veloce o un prezzo più conveniente.






</summary> 
<br>

</details>

### Guida per testare il progetto

1. Installazione di MAMP(se si usa mac os) altrimenti xamp se si usa windows)
Scarica e installa MAMP dal sito ufficiale.
Avvia MAMP e clicca su "Start Servers".
2. Configurazione di MAMP
Crea una nuova cartella nella directory htdocs .
Copia tutti i file del progetto in questa cartella.
3. Creazione del database
Accedi a phpMyAdmin su http://localhost:8888/phpmyadmin.
Crea un nuovo database .
Esegui gli script SQL per creare le tabelle.
4. Esecuzione del progetto
Visita http://localhost:8888/ordini-acquisto nel tuo browser.
Testa le funzionalità ordinando articoli e verificando i fornitori e i tempi di spedizione.
5. Debugging
Controlla i log degli errori in /Applications/MAMP/logs se riscontri problemi.


## Built With

- [![PHP][PHP-badge]][PHP-url]
- [![MySQL][MySQL-badge]][MySQL-url]

[PHP-badge]: https://img.shields.io/badge/PHP-777BB4?style=flat&logo=php&logoColor=white
[MySQL-badge]: https://img.shields.io/badge/MySQL-00618A?style=flat&logo=mysql&logoColor=white
[PHP-url]: https://www.php.net/
[MySQL-url]: https://www.mysql.com/
