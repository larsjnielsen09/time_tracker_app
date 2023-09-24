<?php

header('Content-Type: application/json');

// Database configuration
$servername = "144.76.115.20";
$username = "robotdk_redred";
$password = "ZAQ!xsw2271218ej";
$dbname = "robotdk_electron";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['error' => "Connection failed: " . $conn->connect_error]));
}


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Assuming you're receiving JSON payload
    $data = json_decode(file_get_contents("php://input"), true);

    $kunde = $data['kunde'];
    $dato = $data['dato'];
    $timer = $data['timer'];
    $description = $data['description'];

    // Prepare SQL statement
    $stmt = $conn->prepare("INSERT INTO tasks (kunde, dato, timer, description) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssis", $kunde, $dato, $timer, $description);

    // Execute statement
    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Task added successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to add task']);
    }
}
// Check for GET request to read data
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT id, kunde, dato, timer, description FROM tasks";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $tasks = array();
        while($row = $result->fetch_assoc()) {
            array_push($tasks, $row);
        }
        echo json_encode(array('status' => 'success', 'tasks' => $tasks));
    } else {
        echo json_encode(array('status' => 'error', 'message' => 'No records found.'));
    }
}


// Close connection

?>
