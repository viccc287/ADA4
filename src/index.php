<?php
use Parle\{Parser, ParserException, Lexer, Token};

// Conexión a la base de datos
$mysqli = new mysqli('localhost', 'root', '', 'inverted_index');
$mysqli->set_charset('utf8mb4');

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Manejo de carga de archivos
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['textfiles'])) {
    $uploadDir = 'uploads/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    foreach ($_FILES['textfiles']['tmp_name'] as $key => $tmp_name) {
        $fileName = $_FILES['textfiles']['name'][$key];
        $filePath = $uploadDir . $fileName;
        
        if (move_uploaded_file($tmp_name, $filePath)) {
            processFile($filePath, $fileName);
        }
    }

    generateInvertedIndex();
}

function processFile($filePath, $fileName) {
    $content = file_get_contents($filePath);
    
    preg_match_all('/\p{L}+/u', mb_strtolower($content, 'UTF-8'), $matches);
    $words = $matches[0];
    $wordCount = array_count_values($words);

    $result = $GLOBALS['mysqli']->query("SELECT MAX(doc_id) as max_id FROM posting");
    $row = $result->fetch_assoc();
    $docId = ($row['max_id'] !== null) ? $row['max_id'] + 1 : 1;

    foreach ($wordCount as $word => $frequency) {
        $stmt = $GLOBALS['mysqli']->prepare("INSERT INTO dictionary (term, doc_count, total_frequency) 
                                             VALUES (?, 1, ?) 
                                             ON DUPLICATE KEY UPDATE 
                                             doc_count = doc_count + 1, 
                                             total_frequency = total_frequency + ?");
        $stmt->bind_param("sii", $word, $frequency, $frequency);
        $stmt->execute();

        $stmt = $GLOBALS['mysqli']->prepare("INSERT INTO posting (term, doc_id, frequency, file_name, text_snippet) 
                                             VALUES (?, ?, ?, ?, ?)");
        $snippet = mb_substr($content, max(0, mb_strpos($content, $word) - 25), 50, 'UTF-8');
        $stmt->bind_param("siiss", $word, $docId, $frequency, $fileName, $snippet);
        $stmt->execute();
    }
}

function generateInvertedIndex() {
    // Esta función actualizaría el índice invertido en la base de datos
    // Por simplicidad, asumimos que el índice se actualiza a medida que procesamos cada archivo
}

function parse_query($query)
{
    $parser = new Parser();
    $parser->token('WORD');
    $parser->token('AND');
    $parser->token('OR');
    $parser->token('NOT');
    $parser->token('PATRON');
    $parser->token('LPAREN');
    $parser->token('RPAREN');

    $parser->left('AND OR');
    $prod_start = $parser->push('start', 'query');
    $prod_query = $parser->push('query', 'expression');

    $prod_expression_and = $parser->push('expression', 'expression AND expression');
    $prod_expression_or = $parser->push('expression', 'expression OR expression');
    $prod_expression_terms = $parser->push('expression', 'terms');

    $prod_terms_1 = $parser->push('terms', 'terms term');
    $prod_terms_2 = $parser->push('terms', 'term');
    $prod_terms_not = $parser->push('terms', 'NOT term');

    $prod_term_palabra = $parser->push('term', 'WORD');
    $prod_term_pattern = $parser->push('term', 'PATRON LPAREN WORD RPAREN');

    $parser->build();

    $lexer = new Lexer();
    $lexer->push('AND', $parser->tokenId('AND'));
    $lexer->push('OR', $parser->tokenId('OR'));
    $lexer->push('NOT', $parser->tokenId('NOT'));
    $lexer->push('PATRON', $parser->tokenId('PATRON'));
    $lexer->push('\(', $parser->tokenId('LPAREN'));
    $lexer->push('\)', $parser->tokenId('RPAREN'));
    $lexer->push('[a-zA-Z0-9_.]+', $parser->tokenId('WORD'));
    $lexer->push('\\s+', Token::SKIP);
    $lexer->build();

    $ast = [];

    if (!$parser->validate($query, $lexer)) {
        throw new ParserException('Error sintáctico');
    }

    $parser->consume($query, $lexer);

    while (Parser::ACTION_ERROR != $parser->action && Parser::ACTION_ACCEPT != $parser->action) {
        switch ($parser->action) {
            case Parser::ACTION_ERROR:
                throw new ParserException('Parser error');
            case Parser::ACTION_SHIFT:
            case Parser::ACTION_GOTO:
            case Parser::ACTION_ACCEPT:
                break;
            case Parser::ACTION_REDUCE:
                $reduction = $parser->reduceId;
                switch ($reduction) {
                    case $prod_term_palabra:
                        $word = $parser->sigil(0);
                        $ast[] = ['type' => 'WORD', 'value' => $word];
                        break;
                    case $prod_terms_1:
                        $term = array_pop($ast);
                        $terms = array_pop($ast);
                        $ast[] = ['type' => 'OR', 'left' => $terms, 'right' => $term];
                        break;
                    case $prod_expression_and:
                        $right = array_pop($ast);
                        $left = array_pop($ast);
                        $ast[] = ['type' => 'AND', 'left' => $left, 'right' => $right];
                        break;
                    case $prod_expression_or:
                        $right = array_pop($ast);
                        $left = array_pop($ast);
                        $ast[] = ['type' => 'OR', 'left' => $left, 'right' => $right];
                        break;
                    case $prod_terms_not:
                        $term = array_pop($ast);
                        $ast[] = ['type' => 'NOT', 'term' => $term];
                        break;
                    case $prod_term_pattern:
                        $pattern = $parser->sigil(2);
                        $ast[] = ['type' => 'PATTERN', 'value' => $pattern];
                        break;
                }
                break;
        }
        $parser->advance();
    }

    return $ast[0];
}

function build_sql($ast)
{
    $sql = "SELECT d.term, d.doc_count, d.total_frequency, p.doc_id, p.frequency, p.file_name, p.text_snippet 
            FROM dictionary d
            JOIN posting p ON d.term = p.term
            WHERE ";
    $conditions = build_conditions($ast);
    return $sql . $conditions;
}

function build_conditions($node)
{
    if (!is_array($node)) {
        return $node;
    }

    switch ($node['type']) {
        case 'AND':
            return '(' . build_conditions($node['left']) . ' AND ' . build_conditions($node['right']) . ')';
        case 'OR':
            return '(' . build_conditions($node['left']) . ' OR ' . build_conditions($node['right']) . ')';
        case 'NOT':
            return 'NOT (' . build_conditions($node['term']) . ')';
        case 'WORD':
            return "d.term = '" . addslashes($node['value']) . "'";
        case 'PATTERN':
            return "d.term REGEXP '" . addslashes($node['value']) . "'";
    }
}

function ast_to_json($ast)
{
    if (!is_array($ast)) {
        return ['type' => 'leaf', 'value' => $ast];
    }

    $node = [
        'type' => 'node',
        'value' => $ast['type'] ?? 'Root (OR)',
        'children' => [],
    ];
    foreach ($ast as $key => $value) {
        if ($key !== 'type') {
            $node['children'][] = [
                'label' => $key,
                'node' => ast_to_json($value),
            ];
        }
    }
    return $node;
}

$globalQuery = null;
$astJson = null;

// Procesar la consulta
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['query'])) {
    $query = $_POST['query'];
    global $globalQuery, $astJson;
    $globalQuery = $query;
    $error = null;

    try {
        $parsed_query = parse_query($query);

        $astJson = json_encode(ast_to_json($parsed_query));

        $sql = build_sql($parsed_query);

        $results = $mysqli->query($sql);

        if ($results === false) {
            throw new Exception('Error en la consulta SQL: ' . $mysqli->error);
        }

        $sqlText = $sql;
    } catch (ParserException $e) {
        $error = 'Error en la consulta: ' . $e->getMessage();
    } catch (mysqli_sql_exception $e) {
        $error = 'Error en la base de datos: ' . $e->getMessage();
    } catch (Exception $e) {
        $error = 'Error: ' . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="styles.css">
    <title>Búsqueda de Índice Invertido</title>
    <script>
        var astData = <?php echo $astJson ?? 'null'; ?>;
    </script>
    <script async src="ast-renderer.js"></script>
</head>
<body>
    <div class='title-container'>
        <h1 class='title'>Búsqueda de Índice Invertido</h1>
        <h2 class='subtitle'>Carga de Archivos y Búsqueda</h2>
    </div>

    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>" enctype="multipart/form-data">
        <div class='input-container'>
            <input type="file" name="textfiles[]" multiple accept=".txt">
            <input type="submit" value="Cargar Archivos">
        </div>
    </form>

    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        <div class='input-container'>
            <input type="text" name="query" placeholder="Ingrese su consulta de búsqueda" required>
            <input type="submit" value="Buscar">
        </div>
        <div class='badge-container'>
            <span class='badge'>AND</span>
            <span class='badge'>OR</span>
            <span class='badge'>NOT</span>
            <span class='badge'>PATRON()</span>
        </div>
    </form>

    <?php if (isset($error)): ?>
        <div class="error"><?php echo htmlspecialchars($error); ?></div>
    <?php endif; ?>

    <?php if (isset($globalQuery)): ?>
        <div class="message"><?php echo htmlspecialchars($globalQuery); ?></div>
    <?php endif; ?>

    <?php if (isset($results)): ?>
        <?php if ($results->num_rows > 0): ?>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Término</th>
                            <th>Conteo de Documentos</th>
                            <th>Frecuencia Total</th>
                            <th>ID del Documento</th>
                            <th>Frecuencia</th>
                            <th>Nombre del Archivo</th>
                            <th>Fragmento de Texto</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php while ($row = $results->fetch_assoc()): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($row['term']); ?></td>
                            <td><?php echo htmlspecialchars($row['doc_count']); ?></td>
                            <td><?php echo htmlspecialchars($row['total_frequency']); ?></td>
                            <td><?php echo htmlspecialchars($row['doc_id']); ?></td>
                            <td><?php echo htmlspecialchars($row['frequency']); ?></td>
                            <td><?php echo htmlspecialchars($row['file_name']); ?></td>
                            <td><?php echo htmlspecialchars($row['text_snippet']); ?></td>
                        </tr>
                    <?php endwhile; ?>
                    </tbody>
                </table>
            </div>
        <?php else: ?>
            <span class='message'>No se encontraron resultados.</span>
        <?php endif; ?>
    <?php endif; ?>

    <?php if (isset($sqlText)): ?>
        <code>
            <div>
                <span>
                    <?php echo htmlspecialchars($sqlText); ?>
                </span>
            </div>
        </code>
    <?php endif; ?>

    <?php if (isset($astJson)): ?>
        <canvas id="astCanvas" width="800" height="600"></canvas>
    <?php endif; ?>
</body>
</html>