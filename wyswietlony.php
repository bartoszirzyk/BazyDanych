<!DOCTYPE html>
<html><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta charset="UTF-8">
<title>Przepis</title>
</head>
<body>
<fieldset>



<?php

if (isset($_POST["skladniki"])){


  
  echo"  <form>
  <h3>Nazwa przepisu:</h3>";

       $con='host=localhost dbname=przepisy user=kasia password=tajne';
        $db=pg_connect($con) or die('Nie mozna nawiazac polaczenia: ' . pg_last_error());
       //if($db)
       //  echo "Polaczono ...<br/>";
       //else
       //  echo "Nie mozna sie polaczyc<br/>";
  $skladnik1 = $_POST['skladniki'];
  $query = 'SELECT prze.nazwa FROM przepisy prze, produkty pro, polaczenie p WHERE pro.id_prod= '. $skladnik1 . ' AND p.id_prod=pro.id_prod AND p.id_przep = prze.id_przep;';
  $result = pg_query($query) or die('Nieprawidłowe zapytanie: ' . pg_last_error());


  if(!$result or pg_num_rows($result)==0){
        echo "<input type=\"text\" name=\"przepis\" size=\"50\" value= \" Brak przepisu \" readonly=\"readonly\"/>";
  } else {
   
    while ($line = pg_fetch_row($result)) {
   
        echo "<input type=\"text\" name=\"przepis\" size=\"50\" value= \"" . $line[0] .  "\" readonly=\"readonly\"/>";
      }    
  }

  ?>
  
  </form>

  <h3>Treść przepisu:</h3>
  <form>
  <?php 

  $query = 'SELECT prze.przepis FROM przepisy prze, produkty pro, polaczenie p WHERE pro.id_prod= ' . $skladnik1 . ' AND p.id_prod=pro.id_prod AND p.id_przep = prze.id_przep; ';
  $result = pg_query($query) or die('Nieprawidłowe zapytanie: ' . pg_last_error());

  if(!$result or pg_num_rows($result)==0){
        echo " <textarea name=\"tresc\" cols=\"100\" rows=\"20\" readonly=\"readonly\"> Brak przepisu </textarea> ";
  } else {
      while ($line = pg_fetch_row($result)) {
        echo " <textarea name=\"tresc\" cols=\"100\" rows=\"20\" readonly=\"readonly\">" . $line[0] . "</textarea> ";
          }
  }

  ?>
  </form>



  <h4>Przepis stwożył użytkownik:</h4>

  <?php //connection
       
  $query = 'SELECT u.nazwa from przepisy prze, produkty pro, polaczenie p, uzytkownicy u WHERE pro.id_prod= '. $skladnik1 .' AND p.id_prod=pro.id_prod AND p.id_przep = prze.id_przep AND prze.id_uzyt = u.id_uzyt';
  $result = pg_query($query) or die('Nieprawidłowe zapytanie: ' . pg_last_error());

  if(!$result or pg_num_rows($result)==0){
        echo "<form><input type=\"text\" name=\"przepis\" size=\"25\" readonly=\"readonly\"/></form>";
  } else {
    while ($line = pg_fetch_row($result)) {
   
        echo "<form/><input type=\"text\" name=\"przepis\" size=\"25\" value= \"" 
              . $line[0] .  "\" readonly=\"readonly\"/></form>";

        echo"</br><form action=\"edytuj.php\" method=POST >";
        echo "<button name=\"skladniki\"  value=\"" . $skladnik1 . "\">
              Kliknij, aby edytować</button></form>";

        echo"<form action=\"historia.php\" method=POST >";
        echo "<button name=\"skladniki\"  value=\"" . $skladnik1 . "\">
              Kliknij, aby zobaczyć historię zmian tego przepisu</button></br></form>";
      }
  }
  // Zwolnienie zasobów wyniku zapytania
  pg_free_result($result);
  // Zamknięcie połączenia
  pg_close($db);
} else {

 echo "<p style=\"color:red\">Wybierz chociaż jeden składnik</p>";

      echo "<form action = \"wyszukaj.php\">
      <button>Wróc do formularza</button>
      </form>";

}
?>
  
<form action="wyszukaj.php" method=POST >
        <button name="wroc">Wróć</button></br>
</form>


</fieldset>
</body></html>
