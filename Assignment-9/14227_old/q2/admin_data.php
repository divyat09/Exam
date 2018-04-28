<html>
<head>
</head>

<body>
<?php


$name = $pass = "";
$db = new SQLite3('Registerdb.db');

#if ($_SERVER["REQUEST_METHOD"] == "POST") {

$name = test_input( $_POST['admin_name'] );
$pass = test_input( $_POST['admin_pass'] );

#Admin Check
$db1 = new SQLite3('admin.db');
$qstr="CREATE TABLE IF NOT EXISTS admin( ACCNUMBER INTEGER, PASSWORD TEXT)";
if( $db1->query($qstr) ){
}
else{
	echo $db1->lastErrorMsg();
}

$qstr= "SELECT PASSWORD FROM admin WHERE ACCNUMBER= '$name'";
if( $db1->exec($qstr) ){
	$results= $db1->query($qstr);
	$rows= $results->fetchArray();
	
	if( $pass == $rows['PASSWORD'] ){
		$Status=1;
	}	
	else{
		$Status=0;
	}
}
else{
	echo $db->lastErrorMsg();
}

if( $Status == 0 ){
	echo "<p> Invalid Account/Password <p> ";
	echo "<a href='register.html'>Another Registration</a>";	
	die();
}


# Print Data
$qstr = "SELECT * FROM RegisterData";

if( $db->query($qstr) ){
	echo "<table border='1'>
	<tr>
	<th>NAME</th>
	<th>ADDRESS</th>
	<th>EMAIL</th>
	<th>MOBILE</th>
	<th>ACC NUMBER</th>	
	</tr>";
	$results= $db->query($qstr);
	while( $rows= $results->fetchArray() ){
		echo "<tr>";
		echo "<td>" . $rows['NAME'] . "</td>";
		echo "<td>" . $rows['ADDRESS'] . "</td>";
		echo "<td>" . $rows['EMAIL'] . "</td>";
		echo "<td>" . $rows['MOBILE'] . "</td>";
		echo "<td>" . $rows['ACCNUMBER'] . "</td>";
		echo "</tr>";
	}

}
else{
	echo $db->lastErrorMsg();
}
echo "</table>";

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

?>

<a href="register.html">Another Registration</a>

</body>
</html>
