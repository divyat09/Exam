<html>
<head>
</head>

<body>
<?php


$name = $address = $email = $mobile = $acc_number = $acc_pass = "";
$db = new SQLite3('Registerdb.db');

$qstr="CREATE TABLE IF NOT EXISTS RegisterData ( NAME TEXT, ADDRESS TEXT , EMAIL TEXT, MOBILE INTEGER, ACCNUMBER INTEGER, PASSWORD TEXT)";
if( $db->query($qstr) ){
}
else{
	echo $db->lastErrorMsg();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {

	$name = test_input( $_POST['name'] );
	$address = test_input( $_POST['address'] );
	$email = test_input( $_POST['email'] );
	$mobile = test_input( $_POST['mobile'] ) ;
	$acc_number = test_input( $_POST['acc_number'] ) ;
	$acc_pass = test_input( $_POST['acc_pass'] );
}
else{
	die();
}

#Email Check
$qstr="SELECT EMAIL FROM RegisterData WHERE EMAIL= '$email'";
if ( $db->query($qstr) ){
	$results= $db->query($qstr);
	$rows= $results->fetchArray();

	if($rows['EMAIL']){
		$Status1=0;
	}
	else{
		$Status1=1;
	}
}
else{
	echo $db->lastErrorMsg();
}

if( $Status1 == 0 ){
	echo "<p> Already registered <p>";
	echo "<a href='register.html'>Another Registration</a>";
	die();
}

if( $db1= new SQLite3('account.db') ){
}
else{
	echo "Error in Accessing Account Databse.";
}	

# Password Check
$qstr= "SELECT PASSWORD FROM AccountData WHERE ACCNUMBER= '$acc_number'";
if( $db1->exec($qstr) ){
	$results= $db1->query($qstr);
	$rows= $results->fetchArray();

	if( $acc_pass == $rows['PASSWORD'] ){
		$Status2=1;
	}	
	else{
		$Status2=0;
	}
}
else{	
	echo $db1->lastErrorMsg();
}

if( $Status2 == 0 ){
	echo "<p> Invalid Account/Password </p> ";
        echo "<a href='register.html'>Another Registration</a>";
	die();
}

# Balance Check
$qstr= "SELECT BALANCE FROM AccountData WHERE ACCNUMBER= '$acc_number'";
if( $db1->exec($qstr) ){
	$results= $db1->query($qstr);
	$rows= $results->fetchArray();
	
	if( $rows['BALANCE'] > 1000 ){
		$output= $rows['BALANCE'] - 1000;
                
		$qst= "UPDATE AccountData SET BALANCE= '$output' WHERE ACCNUMBER= '$acc_number'";
                if( $db1->exec($qst) ){
                        $Status3=1;
                }
                else{
                        echo $db1->lastErrorMsg(); 
                }     
	}	
	else{
		$Status3=0;
	}
}
else{
	echo $db1->lastErrorMsg();
}

if( $Status3 == 0 ){
	echo " <p> Insufficient Balance </p> ";
	echo "<a href='register.html'>Another Registration</a>";
	die();
}

# Insert Data
$qstr = " INSERT INTO RegisterData VALUES ('$name', '$address', '$email', ' $mobile ', '$acc_number', '$acc_pass' )";

if( $db->query($qstr) ){
	echo "<p> Successfully Registered <p> ";
        echo "<a href='register.html'>Another Registration</a>";
}
else{
	echo $db->lastErrorMsg();
	echo "Inserting Data Error";
}

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}

?>

</body>
</html>
