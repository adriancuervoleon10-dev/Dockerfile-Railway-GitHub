<?php
// 1. Configuración de la nueva base de datos de Railway
$host     = 'hopper.proxy.rlwy.net';
$port     = '19769';
$db       = 'railway';
$user     = 'root';
$password = 'ouLFOOHGUdtgUNbJjpiXRgedVcNcTHKW';
$charset  = 'utf8mb4';

// 2. Creación del DSN (Data Source Name)
$dsn = "mysql:host=$host;port=$port;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    // 3. Intento de conexión
    $pdo = new PDO($dsn, $user, $password, $options);
    
    // Si la conexión es exitosa, puedes quitar este comentario o usarlo para probar
    // echo "Conexión establecida con éxito a MySQL en Railway";

} catch (\PDOException $e) {
    // 4. En caso de error, lo muestra en pantalla (útil para el despliegue inicial)
    die("Error crítico de conexión: " . $e->getMessage());
}

// --- A partir de aquí va el resto de tu código de la aplicación ---
// Ejemplo de consulta para probar:
/*
$stmt = $pdo->query('SELECT * FROM tu_tabla');
while ($row = $stmt->fetch()) {
    echo $row['nombre'] . "<br>";
}
*/
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - TechStore Railway</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans">

    <nav class="bg-indigo-700 p-4 shadow-xl">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-white text-xl font-bold italic">🚀 ASUS TUF Admin Panel</h1>
            <span class="text-indigo-200 text-sm">Conectado a: <?= $host ?></span>
        </div>
    </nav>

    <div class="container mx-auto px-4 py-10">
        
        <?php if (isset($error)): ?>
            <div class="bg-red-50 border-l-8 border-red-500 p-6 shadow-lg rounded-md">
                <h2 class="text-red-800 font-bold text-lg mb-2">❌ Error de Conexión</h2>
                <p class="text-red-600 font-mono text-sm"><?= $error ?></p>
                <p class="mt-4 text-gray-600 text-sm">Asegúrate de que el script SQL de las tablas haya sido ejecutado en Railway.</p>
            </div>
        <?php else: ?>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-10">
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <p class="text-gray-400 text-xs uppercase font-bold">Total Items</p>
                    <p class="text-2xl font-black text-indigo-600"><?= count($productos) ?></p>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <p class="text-gray-400 text-xs uppercase font-bold">Base de Datos</p>
                    <p class="text-lg font-bold text-green-500">MySQL Online</p>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-2xl overflow-hidden border border-gray-200">
                <table class="w-full text-left">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">ID</th>
                            <th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Producto</th>
                            <th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Categoría</th>
                            <th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase text-right">Precio</th>
                            <th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase text-center">Stock</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <?php if (empty($productos)): ?>
                            <tr>
                                <td colspan="5" class="px-6 py-10 text-center text-gray-400 italic">
                                    No hay datos. Ejecuta el script SQL en el Query Editor de Railway.
                                </td>
                            </tr>
                        <?php endif; ?>
                        
                        <?php foreach ($productos as $p): ?>
                        <tr class="hover:bg-indigo-50/30 transition-all">
                            <td class="px-6 py-4 text-sm font-mono text-gray-400">#<?= $p['id'] ?></td>
                            <td class="px-6 py-4 text-gray-900 font-semibold"><?= htmlspecialchars($p['nombre']) ?></td>
                            <td class="px-6 py-4">
                                <span class="bg-indigo-100 text-indigo-700 px-3 py-1 rounded-full text-xs font-medium">
                                    <?= htmlspecialchars($p['categoria'] ?: 'General') ?>
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right font-bold text-gray-700">$<?= number_format($p['precio'], 2) ?></td>
                            <td class="px-6 py-4 text-center">
                                <span class="text-sm <?= $p['stock'] <= 5 ? 'text-red-500 font-bold' : 'text-gray-500' ?>">
                                    <?= $p['stock'] ?> uds
                                </span>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>

        <p class="text-center mt-10 text-gray-400 text-xs">
            Desplegado mediante Dockerfile en Railway | Motor: MySQL
        </p>
    </div>
</body>
</html>
