<html>

<title>jmeter报告列表</title>
<body>
<?php

$file = scandir(dirname(__FILE__));
rsort($file);
foreach ($file as $path) {
    if (strlen($path) > 5 && is_dir($path)) {
        echo '<a href="../'.($path).'/index.html" target="_blank">'.($path).'<a></br>';
    }
}

?>
</body>
</html>
