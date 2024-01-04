<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="css/style.css" />
        <style><?php include 'css/style.css'; ?></style>
        <title>Generic RPG Database: Find all quest lengths that have an average reward higher than the average reward of all quests</title>
    </head>

    <body>
        <h2>Generic RPG Database: Find all quest lengths that have an average reward higher than the average reward of all quests</h2>
        <div id="editAttributes">
        <h2>Press the button below!!</h2>
	    <form method="GET" action="nestedAggregation.php">
		<input type="hidden" id="displayTuplesRequest" name="displayTuplesRequest">
		<input type="submit" value = "Get Quest Lengths"name="displayTuples"></p>
	</form>
</div>

        <a href="index.php" class="backButton buttons">back</a>

        <?php
        //this tells the system that it's no longer just parsing html; it's now parsing PHP

        echo '<link rel="stylesheet" type="text/css" href="css/style.css">';

        $success = True; //keep track of errors so it redirects the page only if there are no errors
        $db_conn = NULL; // edit the login credentials in connectToDB()
        $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
            //echo "<br>running ".$cmdstr."<br>";
            global $db_conn, $success;

            $statement = OCIParse($db_conn, $cmdstr);
            //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                //echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
                //echo htmlentities($e['message']);
                $success = False;
            }

            return $statement;
        }

        function connectToDB() {
            global $db_conn;

            // Your username is ora_(CWL_ID) and the password is a(student number). For example,
            // ora_platypus is the username and a12345678 is the password.
            $db_conn = oci_connect("ora_andyli02", "a65134645", "dbhost.students.cs.ubc.ca:1522/stu");
            
            if ($db_conn) {
                debugAlertMessage("Database is Connected");
                return true;
            } else {
                debugAlertMessage("Cannot connect to Database");
                $e = OCI_Error(); // For OCILogon errors pass no handle
                echo htmlentities($e['message']);
                return false;
            }
        }

        function disconnectFromDB() {
            global $db_conn;

            debugAlertMessage("Disconnect from Database");
            OCILogoff($db_conn);
        }

    function handleDisplayRequest()
    {
        global $db_conn;
        $result = executePlainSQL("SELECT Q.length, AVG(Q.reward) as reward
        FROM Quest Q
        GROUP BY Q.length
        HAVING AVG(Q.reward) > (SELECT AVG(Q2.reward) FROM Quest Q2)");
        printResult($result);
    }

    function printResult($result) {
        echo "<br>All quest lengths that have an average reward higher than the average reward of all quests:<br>";
        echo "<table>";
        echo "<tr><th>Quest Length</th><th>Quest Reward</th></tr>";
        while ($row = OCI_Fetch_Array($result, OCI_ASSOC)) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($row["LENGTH"], ENT_QUOTES, 'UTF-8') . "</td>";
            echo "<td>" . htmlspecialchars($row["REWARD"], ENT_QUOTES, 'UTF-8') . "</td>";
            echo "</tr>";
        }    
        echo "</table>";
    }

    // HANDLE ALL GET ROUTES
    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
    function handleGETRequest()
    {
        if (connectToDB()) {
            if (array_key_exists('displayTuples', $_GET)) {
                handleDisplayRequest();
            } 
            disconnectFromDB();
        }
    }

    if (isset($_GET['displayTuplesRequest'])) {
        handleGETRequest();
    }
        ?>
    </body>
</html>


