<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet SYSTEM "http://localhost/symbols.ent">

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:block="http://www.semantic-markup.com/xmlns/block"
>

	<xsl:template match="block:b-html">
		<html block:name="b-html">
			<head>
				<title>
					<block:slot name="page-title" />
				</title>
				<block:slot name="page-meta" />
				<block:slot name="page-styles" />
				<block:slot name="page-scripts" />
			</head>
			<body>
				<block:slot name="page-body" />
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>