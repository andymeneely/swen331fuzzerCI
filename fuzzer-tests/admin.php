<!DOCTYPE html>
<html>
    <head>
        <title>You found a guessed page!</title>
    </head>
    <body>
        <p>Awww dang, you got me :(</p>
        <p>Fill out my form and see what happens.</p>

        <form method="get" action="<?= $_SERVER['PHP_SELF'] ?>">
            <label>Where have you co-op'd?</label>
            <input type="text" name="company" />

            <input type="submit" value="Submit" name="Submit">
        </form>

        <?php if (isset($_GET['Submit'])) { ?>
            <br /><br />
            <div>
                Oh hey, I hear <?= $_GET['company'] ?> is a cool place to work!
            </div>
        <?php } ?>

        <a href="sensitive.php">Here's another page.</a>
    </body>
</html>
