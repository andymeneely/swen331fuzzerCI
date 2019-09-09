<?php
    unset($_COOKIE["chocolatechip"]);
    setcookie("chocolatechip", "Hmmmm... Cookies....", time() - 3600);
    if (isset($_POST['Submit'])) {
        setcookie("chocolatechip", time() + 3600 * 2);
    }
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Does your Fuzzer work? Let's find out!</title>
    </head>
    <body>

<?php
      if (isset($_GET['message'])) {
          echo $_GET['message']; //feels gross just writing this...
      }
?>

        <form method="post" action="<?= $_SERVER['PHP_SELF'] ?>">
            <h1>Give me some data!</h1>

            <label>What is your favorite calzone?</label>
            <input type="text" name="calzone">

            <input type="submit" value="Submit" name="Submit">
        </form>

        <p><a href="./CioffiIsTheBest.html">I go no where!</a></p>
        <p><a href="./valid.php">But I go somewhere!</a></p>
        <p><a href="https://www.se.rit.edu/">I go somewhere, but you shouldn't follow me!</a></p>
        <p><a href="./timeout.php">Hopefully I timeout</a></p>

        <br />

        <!-- Thanks PHP Notice alerting -_- -->
        <pre><?php if(isset($_POST['calzone'])) echo $_POST['calzone'] ?></pre>
        <?php
            if (isset($_POST['Submit'])) {
                echo "<p>Do you say mysql or MySQL?</p>";
            }
        ?>
    </body>
</html>
