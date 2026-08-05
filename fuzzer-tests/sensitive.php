<!DOCTYPE html>
<html>
    <head>
        <title>You crawled here. Good work!</title>
    </head>
    <body>
        Hey did you know that your SSN is 123-45-6789? Thought you'd like to know.

<?php
      if (isset($_GET['parrot'])) {
          echo $_GET['parrot']; //feels gross just writing this...
      }
?>
    </body>
</html>
