<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="css/style.css" />
        <style><?php include 'css/style.css'; ?></style>
        <title>Generic RPG Database</title>
    </head>

    <body>
        <h1 id="GUIName">Generic RPG Database</h1>

        <h2>Reset</h2>
        <p>If you wish to reset the table press on the reset button. If this is the first time you're running this page, you MUST use reset</p>

        <form method="POST" action="index.php">
            <input type="hidden" id="resetTables" name="resetTables">
            <p><input type="submit" value="Reset Database" name="reset" class="buttons"></p>
        </form>

        <div id="selectComponent" class="select"></div>

        <div id="selectAttributes"></div>

        <div id="avgTable"></div>

        <div id="divTable"></div>

        <div id="moreOptions"></div>

        <div id="tuplesTable"></div>

        <?php
		// this tells the system that it's no longer just parsing html; it's now parsing PHP

        echo '<link rel="stylesheet" type="text/css" href="css/style.css">';

        $success = True; // keep track of errors so it redirects the page only if there are no errors
        $db_conn = NULL; // edit the login credentials in connectToDB()
        $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())
        
        function createTuplesTable($component, $result) {
            echo "<div id=\"table\">";
            echo "<h3>" . $component . "</h3>";
            while ($row = oci_fetch_array($result, OCI_ASSOC + OCI_RETURN_NULLS)) {
                echo "<div class=\"tuple\">";
                $curr = "";
                $i = 0;
                foreach($row as $key => $value) {
                    if (is_null($value)) continue;
                    if ($i === 0) {
                        $curr .= $key . ": " . $value; 
                        $i++;
                    } else {
                        $curr .= ", " . $key . ": " . $value; 
                    }
                }
                echo "<p>" . $curr . "</p>";
                echo "</div>";
            }
            echo "</div>";
            echo "<script type=\"text/JavaScript\">document.getElementById('tuplesTable').appendChild(document.getElementById('table'));</script>";
        }

        function createComponentsDropdown() {
            echo "<form method=\"get\" action=\"index.php\" id=\"dropdown\">";
            echo "<label for=\"component\">Component</label>";
            echo "<select id=\"component\" name=\"component\">";

            // get all existing tables
            $result = executePlainSQL("SELECT table_name FROM user_tables");
            while ($row = oci_fetch_array($result)) {
                echo "<option value=\"" . $row['TABLE_NAME'] . "\">" . $row['TABLE_NAME'] . "</option>";
            }

            echo "</select>";
            echo "<input type=\"submit\" name=\"selectComponent\" value=\"Select Component\" class=\"buttons\">";
            echo "</form>";

            echo "<script type=\"text/JavaScript\">document.getElementById('selectComponent').appendChild(document.getElementById('dropdown'));</script>";
        }

        function createAttributes($component) {
            echo "<div id=\"attributesForm\">";
            echo "<h3>Filters</h3>";
            echo "<form method=\"get\" action=\"index.php\" class=\"attributes\">";
            echo "<fieldset>";
            echo "<input type=\"hidden\" name=\"attribute[]\" value=\"" . $component . "\">";

            // get all attributes for component
            $result = executePlainSQL("SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name = '" . $component . "'");
            while ($row = oci_fetch_array($result)) {
                echo "<input type=\"checkbox\" name=\"attribute[]\" value=\"" . $row['COLUMN_NAME'] . "\">";
                echo "<label for=\"" . $row['COLUMN_NAME'] . "\">" . $row['COLUMN_NAME'] . "</label>";
            }

            echo "<input type=\"submit\" name=\"setFilters\" class=\"buttons\" value=\"Set Filters\">";
            echo "</fieldset>";
            echo "</form>";
            echo "</div>";

            echo "<script type=\"text/JavaScript\">document.getElementById('selectAttributes').appendChild(document.getElementById('attributesForm'));</script>";

            if ($component == 'PLAYABLECHARACTER') {
                createSelection();
                displayAvgDiv();
            }
            
            if ($component == 'WORKSON') createJoin();
            if ($component == 'MONSTER') {
                // only show add/delete monsters button when monsters is selected
                echo "<a href=\"addDeleteEntry.php\" id=\"addButton\" class=\"buttons\">add/delete monsters</a>";
                echo "<a href=\"editEntry.php\" id=\"editButton\" class=\"buttons\">update monsters</a>";
                echo "<a href=\"aggregationHaving.php\" id=\"aggHavButton\" class=\"backButton buttons\">monster fun fact</a>";
                echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('addButton'));</script>";
                echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('editButton'));</script>";
                echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('aggHavButton'));</script>";
            }
            if ($component == 'QUEST') {
                echo "<a href=\"nestedAggregation.php\" id=\"nestAggButton\" class=\"buttons\">quest fun fact</a>";
                echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('nestAggButton'));</script>";
            }
        }

        function createSelection() {
            echo "<div id=\"selection\">";
            echo "<h3>Specify Conditions</h3>";
            echo "<h5>Use same attribute names as displayed, use a space between each term. <br>
                Numeric comparisons: =, <> (not equal), <, <=, >, >=. <br>
                Alphanumeric comparisons: =; use % to indicate that any number of alphanumeric characters can go there. <br>
                Connect conditions with OR, AND (note that AND is evaluated first unless brackets are used)</h5>";
            echo "<h5>Example: username = %a% AND (speed > 20 OR charlevel != 50)</h5>";
            echo "<form method=\"get\" action=\"index.php\">";
            echo "<input type=\"text\" name=\"selectQuery\">";
            echo "<input type=\"submit\" value=\"Apply Conditions\" name=\"selectSubmit\">";
            echo "</form>";
            echo "</div>";

            echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('selection'));</script>";
        }

        function createJoin() {
            echo "<form method=\"get\" action=\"index.php\" id=\"joinDropdown\">";
            echo "<label for=\"quest\">Show playable characters' names, levels, and classes who have worked on a specific quest:</label>";
            echo "<select id=\"quest\" name=\"quest\">";

            // get all quest titles
            $result = executePlainSQL("SELECT title FROM Quest");
            while ($row = oci_fetch_array($result)) {
                echo "<option value=\"" . $row['TITLE'] . "\">" . $row['TITLE'] . "</option>";
            }

            echo "</select>";
            echo "<input type=\"submit\" name=\"selectQuest\" value=\"Select Quest\" class=\"buttons\">";
            echo "</form>";

            echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('joinDropdown'));</script>";
        }

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
            global $db_conn, $success;

            $statement = oci_parse($db_conn, $cmdstr);
            //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); // For oci_parse errors pass the connection handle
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = oci_execute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Error: Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); // For oci_execute errors pass the statementhandle
                echo htmlentities($e['message']);
                $success = False;
            }

			return $statement;
		}

        function executeBoundSQL($cmdstr, $list) {
        /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		In this case you don't need to create the statement several times. Bound variables cause a statement to only be
		parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		See the sample code below for how this function is used */

			global $db_conn, $success;
			$statement = oci_parse($db_conn, $cmdstr);

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn);
                echo htmlentities($e['message']);
                $success = False;
            }

            foreach ($list as $tuple) {
                foreach ($tuple as $bind => $val) {
                    //echo $val;
                    //echo "<br>".$bind."<br>";
                    oci_bind_by_name($statement, $bind, $val);
                    unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
				}

                $r = oci_execute($statement, OCI_DEFAULT);
                if (!$r) {
                    echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                    $e = OCI_Error($statement); // For oci_execute errors, pass the statementhandle
                    echo htmlentities($e['message']);
                    echo "<br>";
                    $success = False;
                }
            }
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
                $e = OCI_Error(); // For oci_connect errors pass no handle
                echo htmlentities($e['message']);
                return false;
            }
        }

        function disconnectFromDB() {
            global $db_conn;
            debugAlertMessage("Disconnect from Database");
            oci_close($db_conn);
        }

        function handleResetTables() {
            global $db_conn;
            
            // drop old data
            $clear = file_get_contents('clear.sql');
            $sqlRows = explode(";",$clear);
            $lenClear = count($sqlRows);
            for ($x = 0; $x < $lenClear; $x++) {
                executePlainSQL($sqlRows[$x]);
            }

            // run setup SQL file
            $myfile = file_get_contents('setup.sql');
            $sqlRows=explode(";",$myfile);
            $len = count($sqlRows);
            for ($x = 0; $x < $len; $x++) {
                executePlainSQL($sqlRows[$x]);
            }
            
            oci_commit($db_conn);
        }

        function handleGetComponent($component) {
            $result = executePlainSQL("SELECT * FROM " . $component);

            createAttributes($component);
            createTuplesTable($component, $result);
        }

        function handleJoin($quest) {
            $result = executePlainSQL(
                "SELECT username, charlevel, class 
                FROM PlayableCharacter p, WorksOn w
                WHERE quest = '" . $quest . "' AND w.playableCharacter = p.username");

            createAttributes('WORKSON');
            createTuplesTable('WORKSON', $result);
        }

        function handleSetFilters() {
            $attributes = $_GET['attribute'];
            $size = count($attributes);
            $component = $attributes[0];
            // nothing selected, show all attributes
            if ($size === 1) {
                handleGetComponent($component);
                return;
            }
            
            $filter = $attributes[1];
            for ($i = 2; $i < $size; $i++) {
                $filter .= ", " . $attributes[$i];
            }
            $result = executePlainSQL("SELECT DISTINCT " . $filter . " FROM " . $component);

            createAttributes($component);
            createTuplesTable($component, $result);
        }

        function displayAvgDiv() {
            echo "<h2>Class Level</h2>";
            echo "<p>Find average level of each class</p>";
            echo "<form method=\"POST\" action=\"index.php\">";
            echo "<input type=\"hidden\" id=\"findAvgRequest\" name=\"findAvgRequest\">";
            echo "<input type=\"submit\" name=\"avgSubmit\" value=\"Find\" class=\"buttons\">";
            echo "</form>";

            echo "<h2>Playable Character Level</h2>";
            echo "<p>Find levels of playable characters who have worked on every quest</p>";
            echo "<form method=\"POST\" action=\"index.php\">";
            echo "<input type=\"hidden\" id=\"findDivRequest\" name=\"findDivRequest\">";
            echo "<input type=\"submit\" name=\"divSubmit\" value=\"Find\" class=\"buttons\">";
            echo "</form>";
        }

        function handleFindAvg() {
            echo "<div id=\"avgForm\">";

            $result = executePlainSQL('SELECT class, AVG(charLevel) FROM PlayableCharacter GROUP BY class');
            echo"This is the average level per class";
            print "<table border='1'>\n";
            while ($row = oci_fetch_array($result, OCI_ASSOC+OCI_RETURN_NULLS)) {
                print "<tr>\n";
                foreach ($row as $item) {
                    print "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                }
                print "</tr>\n";
            }
            print "</table>\n";
            echo "</div>";
            echo "<script type=\"text/JavaScript\">document.getElementById('avgTable').appendChild(document.getElementById('avgForm'));</script>";
            handleGetComponent('PLAYABLECHARACTER');

        }

        function handleDivision() {
            echo "<div id=\"divForm\">";

            $result = executePlainSQL('SELECT CHARLEVEL FROM PLAYABLECHARACTER WHERE NOT EXISTS ((SELECT TITLE FROM QUEST) MINUS (SELECT W.QUEST FROM WORKSON W WHERE W.PLAYABLECHARACTER = USERNAME))');
            echo "These are the levels of the playable characters that have worked on every quest";
            print "<table border='1'>\n";
            while ($row = oci_fetch_array($result, OCI_ASSOC+OCI_RETURN_NULLS)) {
                print "<tr>\n";
                foreach ($row as $item) {
                    print "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
                }
                print "</tr>\n";
            }
            print "</table>\n";
            echo "</div>";
            echo "<script type=\"text/JavaScript\">document.getElementById('divTable').appendChild(document.getElementById('divForm'));</script>";
            handleGetComponent('PLAYABLECHARACTER');
        }

        // assumes query is non-empty
        function validInput($input) {
            $input = strtolower($input);

            return !str_contains($input, ";") &&
                !str_contains($input, ");") &&
                !str_contains($input, "\"") &&
                !str_contains($input, "'") &&
                !str_contains($input, "*") &&
                !str_contains($input, "drop table") &&
                !str_contains($input, "insert into table") &&
                !str_contains($input, "create table") &&
                !str_contains($input, "update");
        }

        function handleSelection() {
            global $success;
            $selection = $_GET['selectQuery'];

            if ($selection != "" && validInput($selection)) {
                // username = %a% AND (speed > 20 OR level != 50)
                $terms = explode(" ", $selection);
                $query = "";
                $i = 0;
                $end = count($terms);
                while ($i < $end) {
                    // each iteration i doesn't change until the end, we find the entire condition using j then create it
                    $j = 0;
                    // iterate j until we reach end of a condition marked by AND/OR, or end of $terms
                    while ($i + $j < $end && strtoupper($terms[$i + $j]) != 'AND' && strtoupper($terms[$i + $j]) != 'OR') {
                        $j++;
                    }
                    // check the next j values of $terms, starting from i
                    // j should always be 3 unless it's a string comparison where user inputs > 1 word
                    $currQuery = "";
                    for ($curr = 0; $curr < $j; $curr++) {
                        $term = $terms[$i + $curr];
                        if ($curr === 0) {
                            // first term should be the attribute
                            $currQuery .= $term;
                        } else if ($curr === 1 && ($terms[$i] == 'username' || $terms[$i] == 'class' || $terms[$i] == 'pet')) {
                            // check the rest of the condition for %'s, change = to LIKE if at least one exists
                            for ($scan = 1; $scan < $j; $scan++) {
                                if (str_contains($terms[$i + $scan], "%")) {
                                    $currQuery .= " LIKE";
                                    break;
                                }
                            }
                            // if no %'s found use what user provided
                            if ($scan === $j) $currQuery .= " " . $term;
                        } else {
                            // all else gets added, if anything fails it will fail when executed
                            $currQuery .= " ";
                            // string comparisons require quotes
                            if ($terms[$i] == 'username' || $terms[$i] == 'class' || $terms[$i] == 'pet') {
                                if ($curr === 2) {
                                    $term = "'" . $term;
                                }
                                if ($curr === $j-1) {
                                    $term .= "'";
                                }
                            }
                            $currQuery .= $term;
                        }
                    }
                    // add the connector AND/OR
                    if ($i + $j < $end) $currQuery .= " " . $terms[$i + $j];

                    // add condition to entire query
                    if ($i === 0) {
                        $query .= $currQuery;
                    } else {
                        $query .= " " . $currQuery;
                    }
                    
                    // set i = i + j + 1 to continue to next condition
                    $i = $i + $j + 1;
                }
                
                $result = executePlainSQL("SELECT * FROM PLAYABLECHARACTER WHERE " . $query);
                if ($success) {
                    createAttributes('PLAYABLECHARACTER');
                    createTuplesTable('PLAYABLECHARACTER', $result);
                    return;
                }
                // if SQL query unsuccessful it will fall to below
            }
            // invalid input or SQL execution failure
            echo "<h2 id=\"invalidMsg\">Your condition is invalid, please try again!</h2>";
            echo "<script type=\"text/JavaScript\">document.getElementById('moreOptions').appendChild(document.getElementById('invalidMsg'));</script>";
            handleGetComponent('PLAYABLECHARACTER');
        }

        // HANDLE ALL POST ROUTES
	    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('resetTables', $_POST)) {
                    handleResetTables();
                } else if (array_key_exists('attribute', $_POST)) {
                    handleSetFilters();
                } else if (array_key_exists('findAvgRequest', $_POST)) {
                    handleFindAvg();
                } else if (array_key_exists('findDivRequest', $_POST)) {
                    handleDivision();
                }
                disconnectFromDB();
            }
        }

        // HANDLE ALL GET ROUTES
	    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('component', $_GET)) {
                    handleGetComponent($_GET['component']);
                } else if (array_key_exists('attribute', $_GET)) {
                    handleSetFilters();
                } else if (array_key_exists('selectQuery', $_GET)) {
                    handleSelection();
                } else if (array_key_exists('quest', $_GET)) {
                    handleJoin($_GET['quest']);
                }

                disconnectFromDB();
            }
        }
        connectToDB();
        createComponentsDropdown();
        disconnectFromDB();
		if (isset($_POST['resetTables'])|| isset($_POST['selectComponent']) || isset($_POST['setFilters']) || isset($_POST['avgSubmit']) || isset($_POST['divSubmit'])) {
            handlePOSTRequest();
        } else if (isset($_GET['selectComponent']) || isset($_GET['setFilters']) || isset($_GET['selectSubmit']) || isset($_GET['selectQuest'])) {
            handleGETRequest();
        }
		?>
    </body>
</html>