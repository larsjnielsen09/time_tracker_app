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

    $page = isset($_GET['page']) ? $_GET['page'] : 1;
    $limit = 5; // Number of records per page

    error_log("Received Page: $page, Limit: $limit\n");  // Debugging line

    $offset = ($page - 1) * $limit;

    $sql = "SELECT id, kunde, dato, timer, description FROM tasks  ORDER BY id DESC LIMIT $limit OFFSET $offset";
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

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data['id'];

    $stmt = $conn->prepare("DELETE FROM tasks WHERE id = ?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Task deleted successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to delete task']);
    }
}


// Close connection

?>
